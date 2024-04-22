variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-southeast-1" 
}

variable "vpc" {
  type        = list(string)
  description = "vpc"
  default     = ["10.10.0.0/16", "10.30.0.0/16", "10.100.0.0/16", "10.210.0.0/16", "10.230.0.0/16"]
}

variable "name" {
  type        = list(string)
  description = "name"
  default     = ["user-dmz", "dev-dmz", "shared", "product", "testdev"]
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "ec2_key"
  sensitive = true
}

variable "public_key_location" {
  description = "Location of the Public key"
  type        = string
  default     = "~/.ssh/ec2_key.pub"
  sensitive = true
}

variable "private_key_location" {
  description = "Location of the Private key"
  type        = string
  default     = "./ec2_key"
  sensitive = true
}

variable "rules" {
  type    = list
  default = [
    {
      name     = "AWSManagedRulesLinuxRuleSet"
      priority = 10
      aws_rg_name = "AWSManagedRulesLinuxRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesLinuxRuleSetMetric"
    },
    {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 20
      aws_rg_name = "AWSManagedRulesSQLiRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesSQLiRuleSetMetric"
    },
    {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 30
      aws_rg_name = "AWSManagedRulesCommonRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesCommonRuleSetMetric"
    }
  ]
}