# resource "aws_db_subnet_group" "product_rds_subnet" {  
#   name       = "product-rds-subnet-group"
#   subnet_ids = [
#     aws_subnet.product_subnet_02["product_pri_02a"].id,
#     aws_subnet.product_subnet_02["product_pri_02c"].id
#   ]
#   tags = {
#     Name = "product-rds-subnet-group"
#   }
# }

# resource "aws_db_subnet_group" "testdev_rds_subnet" { 
#   name       = "testdev-rds-subnet-group"
#   subnet_ids = [
#     aws_subnet.testdev_subnet_02["testdev_pri_02a"].id,
#     aws_subnet.testdev_subnet_02["testdev_pri_02c"].id
#   ]
#   tags = {
#     Name = "testdev-rds-subnet-group"
#   }
# }

# resource "aws_db_instance" "project_rds" {  
#   identifier = "product-rds"
#   allocated_storage = 50 
#   max_allocated_storage = 100
#   engine = "mysql"
#   engine_version = "8.0.35"
#   instance_class = "db.t3.micro"
#   db_name  = "nadrie" # Initial database name
#   username = "adminuser"
#   password = "adm1np$ssword#"
#   multi_az = true
#   publicly_accessible = false
#   skip_final_snapshot = true
#   db_subnet_group_name  = aws_db_subnet_group.product_rds_subnet.name
#   vpc_security_group_ids = [ aws_security_group.product_rds_sg.id ]
#   tags = {
#       Name = "product-rds"
#   }
# }

# resource "aws_db_instance" "testdev_rds" {  
#   identifier = "testdev-rds"
#   allocated_storage = 50 
#   max_allocated_storage = 100
#   engine = "mysql"
#   engine_version = "8.0.35"
#   instance_class = "db.t3.micro"
#   db_name  = "nadrie" # Initial database name
#   username = "adminuser"
#   password = "adm1np$ssword#"
#   multi_az = true
#   publicly_accessible = false
#   skip_final_snapshot = true
#   db_subnet_group_name  = aws_db_subnet_group.testdev_rds_subnet.name
#   vpc_security_group_ids = [ aws_security_group.testdev_rds_sg.id ]
#   tags = {
#       Name = "testdev-rds"
#   }
# }
