variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-northeast-3" 
}

variable "vpc" { 
  description = "vpc" 
  type        = map(object({
    name  = string
    cidr  = string
  }))
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

variable "subnet_user_dmz" { 
  description = "subnet_user_dmz" 
  type        = map(object({
    name  = string
    cidr  = string
    az = string
    pub = bool
  }))
  default     = {
    user_dmz_pub_01a = {
        name = "user_dmz_pub_01a"
        cidr = "10.10.10.0/24"
        az = "ap-northeast-3a"
        pub = true
        }
    user_dmz_pub_02a = {
        name = "user_dmz_pub_02a"
        cidr = "10.10.20.0/24"
        az = "ap-northeast-3a"
        pub = true
        }
    user_dmz_pri_01a = {
        name = "user_dmz_pri_01a"
        cidr = "10.10.50.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    user_dmz_pub_01c = {
        name = "user_dmz_pub_01c"
        cidr = "10.10.110.0/24"
        az = "ap-northeast-3c"
        pub = true
        }
    user_dmz_pub_02c = {
        name = "user_dmz_pub_02c"
        cidr = "10.10.120.0/24"
        az = "ap-northeast-3c"
        pub = true
        }
    user_dmz_pri_01c = {
        name = "user_dmz_pri_01c"
        cidr = "10.10.150.0/24"
        az = "ap-northeast-3c"
        pub = false
        }
    }
}

variable "subnet_dev_dmz" { 
  description = "subnet_dev_dmz" 
  type        = map(object({
    name  = string
    cidr  = string
    az = string
    pub = bool
  }))
  default     = {
    dev_dmz_pub_01a = {
        name = "dev_dmz_pub_01a"
        cidr = "10.30.10.0/24"
        az = "ap-northeast-3a"
        pub = true
        }
    dev_dmz_pub_02a = {
        name = "dev_dmz_pub_02a"
        cidr = "10.30.20.0/24"
        az = "ap-northeast-3a"
        pub = true
        }
    dev_dmz_pri_01a = {
        name = "dev_dmz_pri_01a"
        cidr = "10.30.50.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    dev_dmz_pub_01c = {
        name = "dev_dmz_pub_01c"
        cidr = "10.30.110.0/24"
        az = "ap-northeast-3c"
        pub = true
        }
    dev_dmz_pub_02c = {
        name = "dev_dmz_pub_02c"
        cidr = "10.30.120.0/24"
        az = "ap-northeast-3c"
        pub = true
        }
    dev_dmz_pri_01c = {
        name = "dev_dmz_pri_01c"
        cidr = "10.30.150.0/24"
        az = "ap-northeast-3c"
        pub = false
        }
    }
}

variable "subnet_shared" { 
  description = "subnet_shared" 
  type        = map(object({
    name  = string
    cidr  = string
    az = string
    pub = bool
  }))
  default     = {
    shared_pri_01a = {
        name = "shared_pri_01a"
        cidr = "10.100.50.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    shared_pri_02a = {
        name = "shared_pri_02a"
        cidr = "10.100.150.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    }
}

variable "subnet_product" { 
  description = "subnet_product" 
  type        = map(object({
    name  = string
    cidr  = string
    az = string
    pub = bool
  }))
  default     = {
    product_pri_01a = {
        name = "product_pri_01a"
        cidr = "10.210.50.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    product_pri_02a = {
        name = "product_pri_02a"
        cidr = "10.210.60.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    product_pri_01c = {
        name = "product_pri_01c"
        cidr = "10.210.150.0/24"
        az = "ap-northeast-3c"
        pub = false
        }
    product_pri_02c = {
        name = "product_pri_02c"
        cidr = "10.210.160.0/24"
        az = "ap-northeast-3c"
        pub = false
        }        
    }
}

variable "subnet_testdev" { 
  description = "subnet_testdev" 
  type        = map(object({
    name  = string
    cidr  = string
    az = string
    pub = bool
  }))
  default     = {
    testdev_pri_01a = {
        name = "testdev_pri_01a"
        cidr = "10.230.50.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    testdev_pri_02a = {
        name = "testdev_pri_02a"
        cidr = "10.230.60.0/24"
        az = "ap-northeast-3a"
        pub = false
        }
    testdev_pri_01c = {
        name = "testdev_pri_01c"
        cidr = "10.230.150.0/24"
        az = "ap-northeast-3c"
        pub = false
        }
    testdev_pri_02c = {
        name = "testdev_pri_02c"
        cidr = "10.230.160.0/24"
        az = "ap-northeast-3c"
        pub = false
        }        
    }
}

variable "eip_count" {
  description = "The number of EIPs to create"
  default     = 4
}

variable "user_dmz_pub_rt" {
  description = "The number of EIPs to create"
  default     = 4
}

variable "user_dmz_pri_rt" { 
  description = "user_dmz_pri_rt" 
  type        = map(object({
    name  = string
    ngw  = string
  }))
  default     = {
    user_dmz_pri_rt_a = {
        name = "user_dmz_pri_rt_a"
        ngw = aws_nat_gateway.user_dmz_nat_a.id
    }
    user_dmz_pri_rt_c = {
        name = "user_dmz_pri_rt_c"
        ngw = aws_nat_gateway.user_dmz_nat_c.id
    }

  }
}

variable "dev_dmz_pri_rt" { 
  description = "dev_dmz_pri_rt" 
  type        = map(object({
    name  = string
    ngw  = string
  }))
  default     = {
    dev_dmz_pri_rt_a = {
        name = "dev_dmz_pri_rt_a"
        ngw = aws_nat_gateway.dev_dmz_nat_a.id
    }
    dev_dmz_pri_rt_c = {
        name = "dev_dmz_pri_rt_c"
        ngw = aws_nat_gateway.dev_dmz_nat_c.id
    }

  }
}