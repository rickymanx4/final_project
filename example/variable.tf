###
# 1. VPC Subnet variables 
###
variable "public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "web_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "app_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "db_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}
###
# 2.AZS variables
###
variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-northeast-3a", "ap-northeast-3a"]
}
###
# 3. region
###
variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-northeast-3" 
}
###
# 4. efs mount point
###
variable "efs_mount_point" {
  description = "Determine the mount point"
  type        = string
  default     = "/home/ec2-user/service"
  sensitive   = true
}
###
# 5. tags
###
variable "testbed_tags" {
  type = map(string)
  description = "(optional) default tags for testbed"
  default = {
    using_for = "testbed"
    environment = "dev"
  }
}
variable "web_asg_tags" {
  type = map(string)
  description = "(optional) default tags for web asg"
  default = {
    layer = "web"
    Group = "private"
    using_for = "asg"
    environment = "service"
  }
}
variable "app_asg_tags" {
  type = map(string)
  description = "(optional) default tags for app asg"
  default = {
    layer = "app"
    Group = "private"
    using_for = "asg"
    environment = "service"
  }
}
variable "bastion_layer_tags" {
  type = map(string)
  description = "(optional) default tags for bastion layer"
  default = {
    layer = "bastion"
    Group = "bastion"
  }
}
variable "web_layer_tags" {
  type = map(string)
  description = "(optional) default tags for web layer"
  default = {
    layer = "web"
    Group = "private"
  }
}
variable "app_layer_tags" {
  type = map(string)
  description = "(optional) default tags for web layer"
  default = {
    layer = "app"
    Group = "private"
  }
}
###
# 6. file destination
###
variable "dest1" {
  description = "dest of key"
  type        = string
  default     = "/home/ec2-user/.ssh/terraform-key"
  sensitive   = true
}
variable "dest2" {
  description = "dest of service"
  type        = string
  default     = "/home/ec2-user/service"
}
variable "dest3" {
  description = "dest of cloud watch config"
  type        = string
  default     = "/home/ec2-user/config.json.j2"
}
# 7. Board File
variable "flask_file_paths" {
  type        = list(string)
  description = "Board_File_Paths"
  default     = [
    "/home/ec2-user/service/blind_web/board.py"
    ]
    sensitive   = true
}

# 8. Dao Files
variable "dao_file_paths" {
  type        = list(string)
  description = "DAO_File_Paths"
  default     = [
    "/home/ec2-user/service/blind_web/blind_board_DAO.py",
    "/home/ec2-user/service/blind_web/blind_member_DAO.py",
    "/home/ec2-user/service/blind_web/blind_reply_DAO.py",
    "/home/ec2-user/service/blind_was/blind_board_DAO.py",
    "/home/ec2-user/service/blind_was/blind_member_DAO.py",
    "/home/ec2-user/service/blind_was/blind_reply_DAO.py"
    ]
    sensitive   = true
}

# 9. Dummy File's Destination
variable "dest_dummy_data" {
  description = "Determine the Directory for Dummy Data"
  type        = string
  default     = "/home/ec2-user/service/dummy_data.sql"
  sensitive   = true
}
########################
# RDS Variables 
########################
variable "db_user_name" { 
  description = "Database User Name" 
  type        = string
  default     = "nana"
  sensitive = true
}
variable "db_user_pass" { 
  description = "Database User Password" 
  type        = string 
  default     = "nana!12345"
  sensitive = true
}
########################
# Key Variables 
########################
variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "terraform-key"
  sensitive = true
}
variable "public_key_location" {
  description = "Location of the Public key"
  type        = string
  default     = "~/.ssh/terraform-key.pub"
  sensitive = true
}
variable "private_key_location" {
  description = "Location of the private key"
  type        = string
  default     = "~/.ssh/terraform-key"
  sensitive = true
}