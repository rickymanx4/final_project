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

variable "user_dmz_lb" { 
  description = "user_dmz_proxy_lb" 
  type        = map(object({
    name  = string
    ec2   = string
  }))
  default     = {
    user-dmz-proxy-tg_a = {
        name = "user-dmz-lb-a"        
        ec2 = "user_dmz_pri_01a"
        }        
    user-dmz-proxy-tg-c = {
        name = "user-dmz-lb-c"
        ec2 = "user_dmz_pri_01c"
        }        
    }
}

variable "dev_dmz_proxy_tg" { 
  description = "dev_dmz_proxy_tg" 
  type        = map(object({
    name  = string
    ec2   = string
  }))
  default     = {
    dev-dmz-proxy-tg_a = {
        name = "dev-dmz-proxy-tg-a"        
        ec2 = "dev_dmz_pri_01a"
        }        
    dev-dmz-proxy-tg-c = {
        name = "dev-dmz-proxy-tg-c"
        ec2 = "dev_dmz_pri_01c"
        }        
    }
}

variable "dev_dmz_lb" { 
  description = "dev_dmz_proxy_lb" 
  type        = map(object({
    name  = string
    ec2   = string
  }))
  default     = {
    dev-dmz-proxy-tg_a = {
        name = "dev-dmz-lb-a"        
        ec2 = "dev_dmz_pri_01a"
        }        
    dev-dmz-proxy-tg-c = {
        name = "dev-dmz-lb-c"
        ec2 = "dev_dmz_pri_01c"
        }        
    }
}