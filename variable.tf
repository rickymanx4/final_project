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


variable "monitoring_ec2" {
  type        = list(string)
  description = "shared_monitoring_ec2"
  default     = ["shared_prometheus_ec2", "shared_grafana_ec2"]
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

variable "tgw_vpc_attach" {
  description = "tgw_vpc_attach"
  type        = map(object({
    name      = string
    vpc_num   = number
    subnet1   = string
    subnet2   = string
  }))
  default     = {
    user_dmz  = {
      name    = user_dmz
      vpc_num = 0
      subnet1 = 0
      subnet2 = 2
    }
    dev_dmz   = {
      name    = dev_dmz
      vpc_num = 1
      subnet1 = 0
      subnet2 = 2
    }  
    shared    = {
      name    = shared
      vpc_num = 2
      subnet1 = 0
      subnet2 = 1
    }    
    product   = {
      name    = prodcut
      vpc_num = 3
      subnet1 = 0
      subnet2 = 1
    }      
    testdev    = {
      name    = testdev
      vpc_num = 4
      subnet1 = 0
      subnet2 = 1
    }  
  }
}