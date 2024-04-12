variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-northeast-3" 
}

variable "vpc" { 
  description = "vpc" 
  type        = list(string)
  default     = {
    user_dmz_vpc = {
        name = "user_dmz_vpc"
        cidr = "10.10.0.0/16"
    }
    dev_dmz_vpc = {
        name = "dev_dmz_vpc"
        cidr = "10.30.0.0/16"
    }
    shared_vpc = {
        name = "shared_vpc"
        cidr = "10.100.0.0/16"
    }
    product_vpc = {
        name = "product_vpc"
        cidr = "10.210.0.0/16"
    }
    testdev_vpc = {
        name = "testdev_vpc"
        cidr = "10.230.0.0/16"
    }
  }
}

variable "subnet_user_dmz_pub" { 
  description = "subnet_user_dmz_pub" 
  type        = list(string)
  default     = {
    user_dmz_pub_01a = {
        name = "user_dmz_pub_01a"
        cidr = "10.10.10.0/24"
        az = "ap-northeast-3a"
        }
    user_dmz_pub_02a = {
        name = "user_dmz_pub_02a"
        cidr = "10.10.20.0/24"
        az = "ap-northeast-3a"
        }
    user_dmz_pub_01c = {
        name = "user_dmz_pub_01c"
        cidr = "10.10.110.0/24"
        az = "ap-northeast-3c"
        }
    user_dmz_pub_02c = {
        name = "user_dmz_pub_02c"
        cidr = "10.10.120.0/24"
        az = "ap-northeast-3c"
        pub = true
        }
    }
}

variable "subnet_user_dmz_pri" { 
  description = "subnet_user_dmz_pri" 
  type        = list(string)
  default     = {
    user_dmz_pri_01a = {
        name = "user_dmz_pri_01a"
        cidr = "10.10.50.0/24"
        az = "ap-northeast-3a"
        }
    user_dmz_pri_01c = {
        name = "user_dmz_pri_01c"
        cidr = "10.10.150.0/24"
        az = "ap-northeast-3c"
        }
    }
}

variable "subnet_dev_dmz_pub" { 
  description = "subnet_dev_dmz_pub" 
  type        = list(string)
  default     = {
    dev_dmz_pub_01a = {
        name = "dev_dmz_pub_01a"
        cidr = "10.30.10.0/24"
        az = "ap-northeast-3a"
        }
    dev_dmz_pub_02a = {
        name = "dev_dmz_pub_02a"
        cidr = "10.30.20.0/24"
        az = "ap-northeast-3a"
        }
    dev_dmz_pub_01c = {
        name = "dev_dmz_pub_01c"
        cidr = "10.30.110.0/24"
        az = "ap-northeast-3c"
        }
    dev_dmz_pub_02c = {
        name = "dev_dmz_pub_02c"
        cidr = "10.30.120.0/24"
        az = "ap-northeast-3c"
        }
    }
}
variable "subnet_dev_dmz_pri" { 
  description = "subnet_dev_dmz_pri" 
  type        = list(string)
  default     = {
    dev_dmz_pri_01a = {
        name = "dev_dmz_pri_01a"
        cidr = "10.30.50.0/24"
        az = "ap-northeast-3a"
        }
    dev_dmz_pri_01c = {
        name = "dev_dmz_pri_01c"
        cidr = "10.30.150.0/24"
        az = "ap-northeast-3c"
        }
    }
}

variable "subnet_shared" { 
  description = "subnet_shared" 
  type        = list(string)
  default     = {
    shared_pri_01a = {
        name = "shared_pri_01a"
        cidr = "10.100.50.0/24"
        az = "ap-northeast-3a"
        }
    shared_pri_02a = {
        name = "shared_pri_02a"
        cidr = "10.100.150.0/24"
        az = "ap-northeast-3a"
        }
    }
}

variable "subnet_product_01" { 
  description = "subnet_product_01" 
  type        = list(string)
  default     = {
    product_pri_01a = {
        name = "product_pri_01a"
        cidr = "10.210.50.0/24"
        az = "ap-northeast-3a"
        }
    product_pri_01c = {
        name = "product_pri_01c"
        cidr = "10.210.150.0/24"
        az = "ap-northeast-3c"
        }     
    }
}

variable "subnet_product_02" { 
  description = "subnet_product_02" 
  type        = list(string)
  default     = {
    product_pri_02a = {
        name = "product_pri_02a"
        cidr = "10.210.60.0/24"
        az = "ap-northeast-3a"
        }          
    product_pri_02c = {
        name = "product_pri_02c"
        cidr = "10.210.160.0/24"
        az = "ap-northeast-3c"
        }        
    }
}

variable "subnet_testdev_01" { 
  description = "subnet_testdev_01" 
  type        = list(string)
  default     = {
    testdev_pri_01a = {
        name = "testdev_pri_01a"
        cidr = "10.230.50.0/24"
        az = "ap-northeast-3a"
        }
    testdev_pri_01c = {
        name = "testdev_pri_01c"
        cidr = "10.230.150.0/24"
        az = "ap-northeast-3c"
        }        
       
    }
}

variable "subnet_testdev_02" { 
  description = "subnet_testdev_c" 
  type        = list(string)
  default     = {
    testdev_pri_02a = {
        name = "testdev_pri_02a"
        cidr = "10.230.60.0/24"
        az = "ap-northeast-3a"
        }        
    testdev_pri_02c = {
        name = "testdev_pri_02c"
        cidr = "10.230.160.0/24"
        az = "ap-northeast-3c"
        }        
    }
}

variable "eip_count" {
  description = "The number of EIPs to create"
  default     = 4
}

variable "proxy_ec2" {
  type        = list(string)
  description = "user_dmz_proxy_ec2"
  default     = ["user_dmz_proxy_a", "user_dmz_proxy_c"]
}


