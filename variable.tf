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



