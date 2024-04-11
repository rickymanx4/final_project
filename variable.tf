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
    {
        name = "user_dmz_vpc"
        cidr = "10.10.0.0/16"
    },
    {
        name = "dev_dmz_vpc"
        cidr = "10.30.0.0/16"
    },
    {
        name = "shared_vpc"
        cidr = "10.100.0.0/16"
    },
    {
        name = "product_vpc"
        cidr = "10.210.0.0/16"
    },
    {
        name = "testdev_vpc"
        cidr = "10.230.0.0/16"
    }
  }
}

# variable "vpc" {
#   type = list(any)
# }

