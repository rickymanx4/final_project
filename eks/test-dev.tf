###
# 1. vpc
###
resource "aws_vpc" "test_dev" {
  cidr_block = local.test_dev_vpc_cidr
  tags = local.test_dev_tags
    
  enable_dns_hostnames      = true
  enable_dns_support        = true
}
###
# 2. subnets
###
resource "aws_subnet" "test_dev_node" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.test_dev.id
  cidr_block          = cidrsubnet(local.test_dev_vpc_cidr, 8, count.index+10)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name                                  = "${local.test_dev_name}-subnet-node-0${count.index+1}"
    Identifier                            = "${local.test_dev_name}-subnet-node"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/test_dev_was"  = "shared"
  }
}
resource "aws_subnet" "test_dev_db" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.test_dev.id
  cidr_block          = cidrsubnet(local.test_dev_vpc_cidr, 8, count.index+100)
  availability_zone   = element(local.azs, count.index)

    tags = {
      Name = "${local.test_dev_name}-subnet-db-0${count.index+1}"
    }
}
resource "aws_subnet" "test_dev_tgw" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.test_dev.id
  cidr_block          = cidrsubnet(local.test_dev_vpc_cidr, 8, count.index+200)
  availability_zone   = element(local.azs, count.index)

    tags = {
      Name = "${local.test_dev_name}-subnet-tgw-0${count.index+1}"
    }
}
###
# 3. routing table
###
resource "aws_route_table" "test_dev" {
  vpc_id = aws_vpc.test_dev.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.test_dev_name}-int-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.test_dev
  ]
}
resource "aws_route_table_association" "test_dev_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.test_dev_node[*].id, count.index)
  route_table_id = aws_route_table.test_dev.id

  depends_on = [
    aws_route_table.test_dev
    ]
}
resource "aws_route_table_association" "test_dev_db_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.test_dev_db[*].id, count.index)
  route_table_id = aws_route_table.test_dev.id

  depends_on = [
    aws_route_table.test_dev
    ]
}
resource "aws_route_table" "test_dev_tgw" {
  vpc_id = aws_vpc.test_dev.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.test_dev_name}-subnet-tgw-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.test_dev
  ]
}
resource "aws_route_table_association" "test_dev_tgw" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.test_dev_tgw[*].id, count.index)
  route_table_id = aws_route_table.test_dev_tgw.id

  depends_on = [
    aws_route_table.test_dev_tgw
    ]
}
###
# 4. security group
###
resource "aws_security_group" "test_dev_endpoint" {
  name = "test-dev-endpoint-sg"
  description = "Security Group for test_dev_endpoint" 
  vpc_id = aws_vpc.test_dev.id
  
  ingress {
  from_port     = 443
  to_port       = 443
  protocol      = "tcp"
  cidr_blocks   = [ "10.0.0.0/8" ]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "test_dev_endpoint_sg"
  }
}
resource "aws_security_group" "test_dev_cluster" {
  name = "test-dev-cluster-sg"
  description = "Security Group for test_dev_cluster" 
  vpc_id = aws_vpc.test_dev.id
  
  ingress {
  from_port     = 443
  to_port       = 443
  protocol      = "tcp"
  cidr_blocks   = [ "10.0.0.0/8" ]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name                                  = "test_dev_cluster_sg"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/test_dev_was"  = "shared"
  }
}
resource "aws_security_group" "test_dev_monitor" {
  name = "test-dev-monitor-sg"
  description = "Security Group for test_dev_monitoring" 
  vpc_id = aws_vpc.test_dev.id
  
  ingress {
  from_port     = 9100
  to_port       = 9100
  protocol      = "tcp"
  cidr_blocks   = [ local.shared_vpc_cidr ]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name                                  = "test_dev_monitor_sg"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/test_dev_was"  = "shared"
  }
}
resource "aws_security_group" "test_dev_pod_to_db" {
  name = "test-dev-pod-to-db-sg"
  description = "Security Group for test_dev pod using db" 
  vpc_id = aws_vpc.test_dev.id
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name                                  = "test_dev_pod_db_sg"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/test_dev_was"  = "shared"
  }
}
resource "aws_security_group" "test_dev_db" {
  name = "project_db" 
  description = "Security Group for RDS DB" 
  vpc_id = aws_vpc.test_dev.id

  ingress {
  from_port     = 3306 
  to_port       = 3306
  protocol      = "tcp"
  security_groups = [aws_security_group.test_dev_pod_to_db.id]
  }
  ingress {
  from_port     = 3306 
  to_port       = 3306
  protocol      = "tcp"
  cidr_blocks  = aws_subnet.shared_int[*].cidr_block 
  }
  ingress {
  from_port     = 3306 
  to_port       = 3306
  protocol      = "tcp"
  cidr_blocks  = aws_subnet.test_dev_node[*].cidr_block
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "test_dev_db_sg"
  }
}
###
# 5. endpoint for eks cluster
###
resource "aws_vpc_endpoint" "test_dev_interface_endpoint" {
  for_each = var.interface_endpoints
  vpc_id              = aws_vpc.test_dev.id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.type
  subnet_ids = aws_subnet.test_dev_node[*].id
  security_group_ids  = [
    aws_security_group.test_dev_endpoint.id,
  ]
  tags = {
    Name              = "test_dev-endpoint-${each.value.name}"
  }
  private_dns_enabled = each.value.name == "s3" ? false : true
}

###
# 6. RDS
###
resource "aws_db_subnet_group" "test_dev" {
  name        = "test-dev-db-subnet-group"
  subnet_ids  = aws_subnet.test_dev_db[*].id
  tags = {
    Name = "test_dev_db_subnet_group"
  }
}
resource "aws_db_instance" "test_dev" {
  identifier              = "test-dev-db"
  allocated_storage       = 50
  max_allocated_storage   = 100
  engine                  = "mariadb"
  engine_version          = "10.11.6"
  instance_class          = "db.t3.micro"
  db_name                 = "test_dev" # Initial Database name
  username                = "${var.db_user_name}"
  password                = "${var.db_user_pass}"
  multi_az                = true
  publicly_accessible     = false
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.test_dev.id
  vpc_security_group_ids  = [ aws_security_group.test_dev_db.id ]
  tags = {
    Name = "test_dev_db"
  }
}