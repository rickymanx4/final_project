##############################################################################
################################### 1. VPC ################################
##############################################################################

resource "aws_vpc" "project_vpc" {
    count = length(var.vpc) 
    cidr_block = element(var.vpc, count.index)
    tags = { 
        Name = "${var.name[count.index]}_vpc"
    }
    enable_dns_hostnames      = true
    enable_dns_support        = true
}