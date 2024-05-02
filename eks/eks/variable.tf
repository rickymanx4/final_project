###
# 1. Key Variables 
###
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
###
# 2. file destination
###
variable "dest1" {
  description = "dest of key"
  type        = string
  default     = "/home/ec2-user/.ssh/terraform-key"
  sensitive   = true
}
variable "dest2" {
  description = "dest of aws"
  type        = string
  default     = "/home/ec2-user/.aws"
}
variable "dest3" {
  description = "dest of alb config"
  type        = string
  default     = "/home/ec2-user/alb"
}