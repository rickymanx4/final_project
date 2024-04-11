resource "aws_db_instance" "blind_rds" {
  identifier = "project-blind-db" 
  allocated_storage = 50 
  max_allocated_storage = 100
  engine = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  db_name  = "blind" # Initial database name
  username = "${var.db_user_name}"
  password = "${var.db_user_pass}"
  multi_az = true
  publicly_accessible = false
  skip_final_snapshot = true
  db_subnet_group_name        = aws_db_subnet_group.default.id
  vpc_security_group_ids = [ aws_security_group.project_db.id ]
  tags = {
      Name = "Blind DB"
  }
}
resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = {
    Name = "My DB subnet group"
  }
}
