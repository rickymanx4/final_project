variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-southeast-1" 
}

# variable "vpc" { 
#   description = "vpc" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#   }))
#   default     = {
#     user_dmz_vpc = {
#         name = "user_dmz_vpc"
#         cidr = "10.10.0.0/16"
#     }
#     dev_dmz_vpc = {
#         name = "dev_dmz_vpc"
#         cidr = "10.30.0.0/16"
#     }
#     shared_vpc = {
#         name = "shared_vpc"
#         cidr = "10.100.0.0/16"
#     }
#     product_vpc = {
#         name = "product_vpc"
#         cidr = "10.210.0.0/16"
#     }
#     testdev_vpc = {
#         name = "testdev_vpc"
#         cidr = "10.230.0.0/16"
#     }
#   }
# }

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

# variable "subnet_user_dmz_pub" { 
#   description = "subnet_user_dmz_pub" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     user_dmz_pub_01a = {
#         name = "user_dmz_pub_01a"
#         cidr = "10.10.10.0/24"
#         az = "ap-southeast-1a"
#         pub = true
#         }
#     user_dmz_pub_02a = {
#         name = "user_dmz_pub_02a"
#         cidr = "10.10.20.0/24"
#         az = "ap-southeast-1a"
#         pub = true
#         }
#     user_dmz_pub_01c = {
#         name = "user_dmz_pub_01c"
#         cidr = "10.10.110.0/24"
#         az = "ap-southeast-1c"
#         pub = true
#         }
#     user_dmz_pub_02c = {
#         name = "user_dmz_pub_02c"
#         cidr = "10.10.120.0/24"
#         az = "ap-southeast-1c"
#         pub = true
#         }
#     }
# }

# variable "subnet_user_dmz_pri" { 
#   description = "subnet_user_dmz_pri" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#     tag = string
#   }))
#   default     = {
#     user_dmz_pri_01a = {
#         name = "user_dmz_pri_01a"
#         cidr = "10.10.50.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         tag = "user_dmz_a"
#         }
#     user_dmz_pri_01c = {
#         name = "user_dmz_pri_01c"
#         cidr = "10.10.150.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         tag = "user_dmz_c"
#         }
#     }
# }

# variable "subnet_dev_dmz_pub" { 
#   description = "subnet_dev_dmz_pub" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     dev_dmz_pub_01a = {
#         name = "dev_dmz_pub_01a"
#         cidr = "10.30.10.0/24"
#         az = "ap-southeast-1a"
#         pub = true
#         }
#     dev_dmz_pub_02a = {
#         name = "dev_dmz_pub_02a"
#         cidr = "10.30.20.0/24"
#         az = "ap-southeast-1a"
#         pub = true
#         }
#     dev_dmz_pub_01c = {
#         name = "dev_dmz_pub_01c"
#         cidr = "10.30.110.0/24"
#         az = "ap-southeast-1c"
#         pub = true
#         }
#     dev_dmz_pub_02c = {
#         name = "dev_dmz_pub_02c"
#         cidr = "10.30.120.0/24"
#         az = "ap-southeast-1c"
#         pub = true
#         }
#     }
# }
# variable "subnet_dev_dmz_pri" { 
#   description = "subnet_dev_dmz_pri" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#     tag = string
#   }))
#   default     = {
#     dev_dmz_pri_01a = {
#         name = "dev_dmz_pri_01a"
#         cidr = "10.30.50.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         tag = "dev_dmz_a"
#         }
#     dev_dmz_pri_01c = {
#         name = "dev_dmz_pri_01c"
#         cidr = "10.30.150.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         tag = "dev_dmz_a"        
#         }
#     }
# }

# variable "subnet_shared" { 
#   description = "subnet_shared" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     shared_pri_01a = {
#         name = "shared_pri_01a"
#         cidr = "10.100.50.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }
#     shared_pri_02a = {
#         name = "shared_pri_02a"
#         cidr = "10.100.150.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }
#     }
# }

# variable "subnet_product_01" { 
#   description = "subnet_product_01" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     product_pri_01a = {
#         name = "product_pri_01a"
#         cidr = "10.210.50.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }
#     product_pri_01c = {
#         name = "product_pri_01c"
#         cidr = "10.210.150.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         }     
#     }
# }

# variable "subnet_product_02" { 
#   description = "subnet_product_02" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     product_pri_02a = {
#         name = "product_pri_02a"
#         cidr = "10.210.60.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }          
#     product_pri_02c = {
#         name = "product_pri_02c"
#         cidr = "10.210.160.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         }        
#     }
# }

# variable "subnet_testdev_01" { 
#   description = "subnet_testdev_01" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     testdev_pri_01a = {
#         name = "testdev_pri_01a"
#         cidr = "10.230.50.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }
#     testdev_pri_01c = {
#         name = "testdev_pri_01c"
#         cidr = "10.230.150.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         }        
       
#     }
# }

# variable "subnet_testdev_02" { 
#   description = "subnet_testdev_c" 
#   type        = map(object({
#     name  = string
#     cidr  = string
#     az = string
#     pub = bool
#   }))
#   default     = {
#     testdev_pri_02a = {
#         name = "testdev_pri_02a"
#         cidr = "10.230.60.0/24"
#         az = "ap-southeast-1a"
#         pub = false
#         }        
#     testdev_pri_02c = {
#         name = "testdev_pri_02c"
#         cidr = "10.230.160.0/24"
#         az = "ap-southeast-1c"
#         pub = false
#         }        
#     }
# }

variable "monitoring_ec2" {
  type        = list(string)
  description = "shared_monitoring_ec2"
  default     = ["shared_prometheus_ec2", "shared_grafana_ec2"]
}

variable "eip_count" {
  description = "The number of EIPs to create"
  default     = 4
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


variable "user_dmz_proxy_tg" { 
  description = "user_dmz_proxy_tg" 
  type        = map(object({
    name  = string
    ec2   = string
  }))
  default     = {
    user-dmz-proxy-tg_a = {
        name = "user-dmz-proxy-tg-a"        
        ec2 = "user_dmz_pri_01a"
        }        
    user-dmz-proxy-tg-c = {
        name = "user-dmz-proxy-tg-c"
        ec2 = "user_dmz_pri_01c"
        }        
    }
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