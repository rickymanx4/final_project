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
    vpc1 = {
        name = "user_dmz_vpc"
        cidr = "10.10.0.0/16"
    }
    vpc2 = {
        name = "dev_dmz_vpc"
        cidr = "10.30.0.0/16"
    }
    vpc3 = {
        name = "shared_vpc"
        cidr = "10.100.0.0/16"
    }
    vpc4 = {
        name = "product_vpc"
        cidr = "10.210.0.0/16"
    }
    vpc5 = {
        name = "testdev_vpc"
        cidr = "10.230.0.0/16"
    }
  }
}

# variable "vpc" {
#   type = list(any)
# }

