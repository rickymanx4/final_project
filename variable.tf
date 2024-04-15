variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-southeast-1" 
}

variable "vpc" {
  type        = list(string)
  description = "vpc"
  default     = ["10.10.0.0/16", "10.30.0.0/16", "10.100.0.0/16", "10.210.0.0/16", "10.230.0.0/16"]
}

variable "name" {
  type        = list(string)
  description = "name"
  default     = ["user_dmz", "dev_dmz", "shared", "product", "testdev"]
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "ec2_key"
  sensitive = true
}

variable "public_key_location" {
  description = "Location of the Public key"
  type        = string
  default     = "~/.ssh/ec2_key.pub"
  sensitive = true
}

# variable "tgw_vpc_attach" {
#   description = "tgw_vpc_attach"
#   type        = map(object({
#     name      = string
#     vpc   = string
#     subnet1   = string
#     subnet2   = string
#   }))
#   default     = {
#     user_dmz  = {
#       name    = "user_dmz_tgw_attach"
#       vpc     = "aws_vpc.project_vpc[0].id"
#       subnet1 = "aws_subnet.subnet_user_dmz_pub[0].id"
#       subnet2 = "aws_subnet.subnet_user_dmz_pub[2].id"
#     },
#     dev_dmz   = {
#       name    = "dev_dmz_tgw_attach"
#       vpc     = "aws_vpc.project_vpc[1].id"
#       subnet1 = "aws_subnet.subnet_dev_dmz_pub[0].id"
#       subnet2 = "aws_subnet.subnet_dev_dmz_pub[2].id"
#     },
#     shared    = {
#       name    = "shared_tgw_attach"
#       vpc     = "aws_vpc.project_vpc[2].id"
#       subnet1 = "aws_subnet.subnet_shared_pri[0].id"
#       subnet2 = "aws_subnet.subnet_shared_pri[1].id"

#     },    
#     product   = {
#       name    = "prodcut_tgw_attach"
#       vpc     = "aws_vpc.project_vpc[3].id"
#       subnet1 = "aws_subnet.subnet_product_pri[0].id"
#       subnet2 = "aws_subnet.subnet_product_pri[1].id"
#     },      
#     testdev    = {
#       name    = "testdev_tgw_attach"
#       vpc     = "aws_vpc.project_vpc[4].id"
#       subnet1 = "aws_subnet.subnet_testdev_pri[0].id"
#       subnet2 = "aws_subnet.subnet_testdev_pri[1].id"
#     }  
#   }
# }