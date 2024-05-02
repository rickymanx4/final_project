###
# 1. vpc
###
resource "aws_vpc" "prod" {
  cidr_block = local.prod_vpc_cidr
  tags = local.prod_tags
    
  enable_dns_hostnames      = true
  enable_dns_support        = true
}
###
# 2. subnets
###
resource "aws_subnet" "prod_node" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.prod.id
  cidr_block          = cidrsubnet(local.prod_vpc_cidr, 8, count.index+10)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name                              = "${local.prod_name}-subnet-node-0${count.index+1}"
    Identifier                        = "${local.prod_name}-subnet-node"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/prod_was"  = "shared"
  }
}
resource "aws_subnet" "prod_db" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.prod.id
  cidr_block          = cidrsubnet(local.prod_vpc_cidr, 8, count.index+100)
  availability_zone   = element(local.azs, count.index)

    tags = {
      Name = "${local.prod_name}-subnet-db-0${count.index+1}"
    }
}
resource "aws_subnet" "prod_tgw" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.prod.id
  cidr_block          = cidrsubnet(local.prod_vpc_cidr, 8, count.index+200)
  availability_zone   = element(local.azs, count.index)

    tags = {
      Name = "${local.prod_name}-subnet-tgw-0${count.index+1}"
    }
}
###
# 3. routing table
###
resource "aws_route_table" "prod" {
  vpc_id = aws_vpc.prod.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.prod_name}-int-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.prod
  ]
}
resource "aws_route_table_association" "prod_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.prod_node[*].id, count.index)
  route_table_id = aws_route_table.prod.id

  depends_on = [
    aws_route_table.prod
  ]
}
resource "aws_route_table_association" "prod_db_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.prod_db[*].id, count.index)
  route_table_id = aws_route_table.prod.id

  depends_on = [
    aws_route_table.prod
  ]
}
resource "aws_route_table" "prod_tgw" {
  vpc_id = aws_vpc.prod.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.prod_name}-subnet-tgw-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.prod
  ]
}
resource "aws_route_table_association" "prod_tgw" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.prod_tgw[*].id, count.index)
  route_table_id = aws_route_table.prod_tgw.id

  depends_on = [
    aws_route_table.prod_tgw
    ]
}
###
# 4. security group
###
resource "aws_security_group" "prod_endpoint" {
  name = "prod-endpoint-sg"
  description = "Security Group for prod_endpoint" 
  vpc_id = aws_vpc.prod.id
  
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
    Name = "prod_endpoint_sg"
  }
}
resource "aws_security_group" "prod_cluster" {
  name = "prod-cluster-sg"
  description = "Security Group for prod_cluster" 
  vpc_id = aws_vpc.prod.id
  
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
    Name                              = "prod_cluster_sg"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/prod_was"  = "shared"
  }
}
resource "aws_security_group" "prod_monitor" {
  name = "prod-monitor-sg"
  description = "Security Group for prod_monitoring" 
  vpc_id = aws_vpc.prod.id
  
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
    Name                                  = "prod_monitor_sg"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/prod_was"  = "shared"
  }
}
resource "aws_security_group" "prod_pod_to_db" {
  name = "test-dev-pod-db-sg"
  description = "Security Group for prod pod using db" 
  vpc_id = aws_vpc.prod.id
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name                                  = "prod_pod_db_sg"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/prod_was"  = "shared"
  }
}
resource "aws_security_group" "prod_db" {
  name = "project_db" 
  description = "Security Group for RDS DB" 
  vpc_id = aws_vpc.prod.id

  ingress {
  from_port     = 3306 
  to_port       = 3306
  protocol      = "tcp"
  security_groups = [ aws_security_group.prod_pod_to_db.id ]
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
  cidr_blocks  = aws_subnet.prod_node[*].cidr_block
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "prod_db_sg"
  }
}
###
# 5. endpoint for eks cluster
###
resource "aws_vpc_endpoint" "prod_interface_endpoint" {
  for_each = var.interface_endpoints
  vpc_id              = aws_vpc.prod.id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.type
  subnet_ids = aws_subnet.prod_node[*].id
  security_group_ids  = [
    aws_security_group.prod_endpoint.id,
  ]
  tags = {
    Name              = "prod-endpoint-${each.value.name}"
  }
  private_dns_enabled = each.value.name == "s3" ? false : true
}

###
# 6. RDS
###
# resource "aws_db_subnet_group" "prod" {
#   name        = "prod-db-subnet-group"
#   subnet_ids  = aws_subnet.prod_db[*].id
#   tags = {
#     Name = "prod_db_subnet_group"
#   }
# }
# resource "aws_db_instance" "prod" {
#   identifier              = "prod-db"
#   allocated_storage       = 50
#   max_allocated_storage   = 100
#   engine                  = "mariadb"
#   engine_version          = "10.11.6"
#   instance_class          = "db.t3.micro"
#   db_name                 = "prod" # Initial Database name
#   username                = "${var.db_user_name}"
#   password                = "${var.db_user_pass}"
#   multi_az                = true
#   publicly_accessible     = false
#   skip_final_snapshot     = true
#   db_subnet_group_name    = aws_db_subnet_group.prod.id
#   vpc_security_group_ids  = [ aws_security_group.prod_db.id ]
#   tags = {
#     Name = "prod_db"
#   }
# }