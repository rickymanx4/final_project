# variable "vpc" {
#   type = list(any)
# }

resource "aws_vpc" "project_vpc" {
    for_each = var.vpc 
    cidr_block = each.value.cidr
    tags = { 
        Name = each.value.name
    }
    enable_dns_hostnames      = true
    enable_dns_support        = true
    }