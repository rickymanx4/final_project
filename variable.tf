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

variable "shared_int" {
  type = map(object({
    name = string
    port = string
  }))
  default = {
    "prometheus" = {
      name = "prometheus"
      port = "1111"
    },
    "grafana" = {
      name = "grafana"
      port = "2222"
    },
    "elk" = {
      name = "elk"
      port = "3333"
    },
    "eks" = {
      name = "eks"
      port = "4444"
    },
  }
}