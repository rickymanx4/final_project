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

variable "subnet" { 
  description = "subnet" 
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


