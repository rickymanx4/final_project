###
# 1. subnets
###
data "aws_subnets" "test_dev_node" {
  filter {
    name   = "tag:Identifier"
    values = ["test-dev-subnet-node"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
data "aws_subnets" "prod_node" {
  filter {
    name   = "tag:Identifier"
    values = ["production-subnet-node"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
###
# 2. security group
###
data "aws_security_groups" "test_dev_cluster" {
  filter {
    name   = "tag:Name"
    values = ["test_dev_cluster_sg"]
  }
}
data "aws_security_groups" "prod_cluster" {
  filter {
    name   = "tag:Name"
    values = ["prod_cluster_sg"]
  }
}
data "aws_security_groups" "test_dev_monitor" {
  filter {
    name   = "tag:Name"
    values = ["test-dev-monitor-sg"]
  }
}
data "aws_security_groups" "prod_monitor" {
  filter {
    name   = "tag:Name"
    values = ["prod_monitor_sg"]
  }
}
###
# 3. assume_role
###
data "aws_iam_policy_document" "cluster_assume_role" { 
  statement { 
    effect = "Allow" 
    principals { 
      type        = "Service" 
      identifiers = ["eks.amazonaws.com"] 
    } 
    actions = ["sts:AssumeRole"] 
  } 
}
data "aws_iam_policy_document" "node_assume_role" { 
  statement { 
    effect = "Allow" 
    principals { 
      type        = "Service" 
      identifiers = ["ec2.amazonaws.com"] 
    } 
    actions = ["sts:AssumeRole"] 
  } 
}
###
# 4. dns name
###
data "aws_lb" "dev_dmz_lb"{
  name  = "dev-dmz-lb"
}
data "aws_lb" "shared_int_lb"{
  name  = "shared-int-lb"
}
###
# 5. key pair
###
data "aws_key_pair" "example" {
  key_name           = "terraform-key"
  include_public_key = true
}