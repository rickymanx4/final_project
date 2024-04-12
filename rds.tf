# resource "aws_db_instance" "project_rds" {
  
#   identifier = element(var.rds, count.index)
#   allocated_storage = 50 
#   max_allocated_storage = 100
#   engine = "mysql"
#   engine_version = "8.0.35"
#   instance_class = "db.t3.micro"
#   db_name  = "nadrie" # Initial database name
#   username = "adminuser"
#   password = "adm1n@@"
#   multi_az = true
#   publicly_accessible = false
#   skip_final_snapshot = true
#   db_subnet_group_name  = aws_db_subnet_group.default.id
#   vpc_security_group_ids = [ aws_security_group.project_db.id ]
#   tags = {
#       Name = element(var.rds, count.index)
#   }
# }
resource "aws_db_subnet_group" "product_rds_subnet" {  
  name       = "product-rds-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_product_01["product_pri_01a"].id,
    aws_subnet.subnet_product_02["product_pri_02a"].id
  ]
  tags = {
    Name = "product-rds-subnet-group"
  }
}

resource "aws_db_subnet_group" "testdev_rds_subnet" {  
  name       = "testdev-rds-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_testdev_01["testdev_pri_01a"].id,
    aws_subnet.subnet_testdev_02["testdev_pri_02a"].id
  ]
  tags = {
    Name = "testdev-rds-subnet-group"
  }
}
