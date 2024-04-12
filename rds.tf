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
  for_each =  var.subnet_product_02
  name       = "product-rds-subnet-group"
  subnet_ids = aws_subnet.product_subnet_02[each.key].id
  tags = {
    Name = "product-rds-subnet-group"
  }
}

resource "aws_db_subnet_group" "testdev_rds_subnet" { 
  for_each =  var.subnet_testdev_02
  name       = "testdev-rds-subnet-group"
  subnet_ids = [
    aws_subnet.testdev_subnet_02["testdev_pri_02a"].id,
    aws_subnet.testdev_subnet_02["testdev_pri_02c"].id
  ]
  tags = {
    Name = "testdev-rds-subnet-group"
  }
}
