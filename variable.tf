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
    # linux os rule
    {
      name     = "AWSManagedRulesLinuxRuleSet"
      priority = 10
      aws_rg_name = "AWSManagedRulesLinuxRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesLinuxRuleSetMetric"
    },
    # SQL database rule (SQL injection)
    {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 20
      aws_rg_name = "AWSManagedRulesSQLiRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesSQLiRuleSetMetric"
    },
    # core rule set (CRS) rule XSS
    {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 30
      aws_rg_name = "AWSManagedRulesCommonRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesCommonRuleSetMetric"
    },
    # posix os rule
    {
      name     = "AWSManagedRulesUnixRuleSet"
      priority = 40
      aws_rg_name = "AWSManagedRulesUnixRuleSet"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesUnixRuleSetMetric"
    },
    # amazon IP reputation list managed rule
    {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 50
      aws_rg_name = "AWSManagedRulesAmazonIpReputationList"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesAmazonIpReputationListmetric"
    },
    # anonymous IP list rule
    {
      name     = "AWSManagedRulesAnonymousIpList"
      priority = 60
      aws_rg_name = "AWSManagedRulesAnonymousIpList"
      aws_rg_vendor_name = "AWS"
      metric_name = "AWSManagedRulesAnonymousIpList"
    }             
  ]
}