resource "aws_vpc" "project_vpc" {
cidr_block = "10.0.0.0/16" 
tags = { 
    Name = "project_VPC"
  }
enable_dns_hostnames      = true
enable_dns_support        = true
}