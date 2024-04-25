locals {
    tgw_name                = "project-tgw"

    region                  = "ap-northeast-2"

    names                   = ["user_dmz", "dev_dmz", "shared", "product", "testdev"]

    user_dmz_pub_subnet     = ["10.10.10.0/24", "10.10.20.0/24", "10.10.200.0/28", "10.10.200.16/28", "10.10.110.0/24", "10.10.120.0/24"]
    user_dmz_pri_subnet     = ["10.10.50.0/24", "10.10.60.0/24", "10.10.210.0/28", "10.10.220.0/28"]
    dev_dmz_pub_subnet      = ["10.30.10.0/24", "10.30.20.0/24", "10.20.200.0/28", "10.20.200.16/28", "10.30.110.0/24", "10.30.120.0/24"]
    dev_dmz_pri_subnet      = ["10.30.50.0/24", "10.30.60.0/24", "10.30.210.0/28", "10.30.220.0/28"]    
    shared_01_subnet        = ["10.100.10.0/24", "10.100.20.0/24"]
    shared_02_subnet        = ["10.100.110.0/24", "10.100.120.0/24"]   
    product_subnet          = ["10.210.10.0/24", "10.210.20.0/24","10.210.110.0/24", "10.210.120.0/24", "10.210.210.0/24", "10.210.220.0/24" ]
    testdev_subnet          = ["10.230.10.0/24", "10.230.20.0/24", "10.230.110.0/24", "10.230.120.0/24", "10.230.210.0/24", "10.230.220.0/24"]
    
    azs_2                   = ["ap-northeast-2a", "ap-northeast-2c"]
    azs_6                   = ["ap-northeast-2a", "ap-northeast-2c",  "ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2a", "ap-northeast-2c",]
    az_ac                   = ["a", "c"]
    az_ac_6                 = ["a", "c", "a", "c", "a", "c"]

    user_dev_vpc            = tolist(slice(aws_vpc.project_vpc[*].id, 0, 2))
    prod_test_vpc           = tolist(slice(aws_vpc.project_vpc[*].id, 3, 5))

    nat_subnet              = tolist(data.aws_subnet.nat_subnet[*].id)

    user_eip                = tolist(slice(aws_eip.dmz_eip[*].id, 0, 2))
    dev_eip                 = tolist(slice(aws_eip.dmz_eip[*].id, 2, 4))

    user_dev_tgw_rt         = tolist(slice(data.aws_ec2_transit_gateway_vpc_attachment.shared_tgw_rt[*], 0, 2))
    prod_test_tgw_rt        = tolist(slice(data.aws_ec2_transit_gateway_vpc_attachment.shared_tgw_rt[*], 3, 5))

    proxy_sg                = tolist(data.aws_security_group.proxy_sg[*].id)

    user_dmz_alb            = tolist(data.aws_lb.user_alb_arn[*].arn)
    dev_dmz_alb             = tolist(data.aws_lb.dev_alb_arn[*].arn)

    dmz_ports               = [22, 80, 9999, 8888]    
    shared_ext_ports        = [5555, 6666]
    shared_int_ports        = [1111, 2222, 3333, 4444]               
    prodtest_lb_ports       = [7777, 8888]             
    product_int_ports       = [1001, 2002, 3003, 4004]             
    testdev_int_ports       = [5005, 6006, 7007, 8008]

    shared_ec2_name         = ["prometheus", "grafana", "elk", "eks"]
    prodtest_ec2_name       = ["node-1", "node-2", "rds-primary", "rds-stanby"]

    userdev_pub_name        = ["nat", "nat", "nwf", "nwf", "lb", "lb"]
    userdev_pri_name        = ["proxy", "proxy", "tgw", "tgw"]    
    shared_name             = ["nexus", "control"]
    prodtest_name           = ["node", "node", "rds", "rds", "tgw", "tgw"]
    cf_origin_name          = ["user_dmz_lb_a", "user_dmz_lb_c", "user_dmz_group"]

    domain_name             = "nadri-project.com"
    host_zone               = "Z07664632DQ4G268CW0D1"
    acm_cert                = "arn:aws:acm:us-east-1:707677861059:certificate/9f1b94c3-b1cd-4de1-b080-20094264264e"

    waf_ruleset             = ["AWSManagedRulesCommonRuleSet", "AWSManagedRulesSQLiRuleSet","AWSManagedRulesLinuxRuleSet"]
    wacl_name               = ["cf-wacl", "alb-wacl"]
    wacl_scope              = ["CLOUDFRONT", "REGIONAL"]
}