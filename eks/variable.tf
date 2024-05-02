###
# 1. Key Variables 
###
variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "terraform-key"
  sensitive = true
}
variable "public_key_location" {
  description = "Location of the Public key"
  type        = string
  default     = "~/.ssh/terraform-key.pub"
  sensitive = true
}
variable "private_key_location" {
  description = "Location of the private key"
  type        = string
  default     = "~/.ssh/terraform-key"
  sensitive = true
}
###
# 2. tags
###
variable "dmz_tags" {
  type = map(string)
  description = "(optional) default tags for dmz"
  default = {
    Area   = "dmz"
  }
}
variable "shared_tags" {
  type = map(string)
  description = "(optional) default tags for shared"
  default = {
    Area   = "shared"
  }
}
variable "dev_tags" {
  type = map(string)
  description = "(optional) default tags for dev"
  default = {
    User   = "dev"
  }
}
variable "user_tags" {
  type = map(string)
  description = "(optional) default tags for dev"
  default = {
    User   = "user"
  }
}
variable "test_tags" {
  type = map(string)
  description = "(optional) default tags for Test"
  default = {
    Environment   = "test"
  }
}
variable "prod_tags" {
  type = map(string)
  description = "(optional) default tags for prod"
  default = {
    Environment   = "prod"
  }
}
###
# 3. shared int
###
variable "shared_int" {
  type = map(object({
    name        = string
    svc_name    = optional(string)
    port        = optional(string)
    svc_port    = optional(string)
    listener    = optional(string)
    dmz_listen  = optional(string)
    instance    = bool
  }))
  default = {
    "prom-grafa" = {
      name        = "prom-grafa"
      svc_name    = "prometheus"
      port        = "1000"
      svc_port    = "9090"
      listener    = "1000"
      dmz_listen  = "8888"
      instance    = true
    },
    "grafana" = {
      name        = "grafana"
      svc_name    = "grafana"
      svc_port    = "3000"
      listener    = "2000"
      dmz_listen  = "7777"
      instance    = false
    },
    "eks_master" = {
      name        = "eks-master"
      port        = "3000"
      instance    = true
    },
    # "ELK" = {
    #   name        = "elk"
    #   port        = "4000"
    #   instance    = true
    # },
  }
}
###
# 4. RDS Variables 
###
variable "db_user_name" { 
  description = "Database User Name" 
  type        = string
  default     = "nana"
  sensitive = true
}
variable "db_user_pass" { 
  description = "Database User Password" 
  type        = string 
  default     = "nana!12345"
  sensitive = true
}
###
# 5. endpoints for eks
###
variable "interface_endpoints" {
  type = map(object({
    name         = string
    service_name = string
    type         = string
  }))
  default = {
    "ecr-api" = {
      name         = "ecr-api"
      service_name = "com.amazonaws.us-west-2.ecr.api"
      type         = "Interface"
    },
    "ecr-dkr" = {
      name         = "ecr-dkr"
      service_name = "com.amazonaws.us-west-2.ecr.dkr"
      type         = "Interface"
    },
    "ec2" = {
      name         = "ec2"
      service_name = "com.amazonaws.us-west-2.ec2"
      type         = "Interface"
    },
    "elb" = {
      name         = "elb"
      service_name = "com.amazonaws.us-west-2.elasticloadbalancing"
      type         = "Interface"
    },
    "logs" = {
      name         = "logs"
      service_name = "com.amazonaws.us-west-2.logs"
      type         = "Interface"
    },
    "sts" = {
      name         = "sts"
      service_name = "com.amazonaws.us-west-2.sts"
      type         = "Interface"
    },
    "xray" = {
      name         = "xray"
      service_name = "com.amazonaws.us-west-2.xray"
      type         = "Interface"
    },
    "s3" = {
      name         = "s3"
      service_name = "com.amazonaws.us-west-2.s3"
      type         = "Interface"
    },
    "autoscaling" = {
      name         = "autoscaling"
      service_name = "com.amazonaws.us-west-2.autoscaling"
      type         = "Interface"
    }
  }
}
