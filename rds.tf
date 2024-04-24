##############################################################################
#################################### 1.rds_subnet ############################
##############################################################################

# resource "aws_db_subnet_group" "product_rds_subnet" {  
#   count = 2
#   name       = "${local.names[3]}-subnetgroup"
#   subnet_ids = [aws_subnet.subnet_product_pri_02[count.index + 4].id]
#   tags = {
#     Name = "${local.names[3]}-subnetgroup"
# }

# resource "aws_db_subnet_group" "testdev_rds_subnet" { 
#   count      = 2
#   name       = "${local.names[4]}-subnetgroup"
#   subnet_ids = [aws_subnet.subnet_testdev_pri_02[count.index + 4].id]
#   tags = {
#     Name = "${local.names[4]}-subnetgroup"
#   }
# }

##############################################################################
#################################### 2.rds_instance ##########################
##############################################################################

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
#   db_subnet_group_name  = aws_db_subnet_group.product_rds_subnet[0].name
#   vpc_security_group_ids = [ aws_security_group.product_rds_sg.id ]
#   tags = {
#       Name = "${local.names[3]}-rds"
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
#   db_subnet_group_name  = aws_db_subnet_group.testdev_rds_subnet[0].name
#   vpc_security_group_ids = [ aws_security_group.testdev_rds_sg.id ]
#   tags = {
#       Name = "${local.names[4]}-subnetgroup"
#   }
# }
