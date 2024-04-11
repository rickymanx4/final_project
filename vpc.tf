resource "aws_vpc" "project_vpc" {
    for_each = list(vars.vpc)
    cidr_block = each.value["cidr"]
    tags = { 
        name = each.value["name"]
    }
    enable_dns_hostnames      = true
    enable_dns_support        = true
    }