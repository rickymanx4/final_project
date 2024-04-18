locals {
    tgw_name                = "project-tgw"

    region                  = "ap-southeast-1"

    names                   = ["user_dmz", "dev_dmz", "shared", "product", "testdev"]

    user_dmz_pub_subnet     = ["10.10.10.0/24", "10.10.20.0/24", "10.10.110.0/24", "10.10.120.0/24"]
    user_dmz_pri_subnet     = ["10.10.50.0/24", "10.10.150.0/24"]
    dev_dmz_pub_subnet      = ["10.30.10.0/24", "10.30.20.0/24", "10.30.110.0/24", "10.30.120.0/24"]
    dev_dmz_pri_subnet      = ["10.30.50.0/24", "10.30.150.0/24"]    
    shared_01_subnet        = ["10.100.10.0/24", "10.100.20.0/24"]
    shared_02_subnet        = ["10.100.110.0/24", "10.100.120.0/24"]   
    product_01_subnet       = ["10.210.50.0/24", "10.210.150.0/24"]
    product_02_subnet       = ["10.210.60.0/24", "10.210.160.0/24"]    
    testdev_01_subnet       = ["10.230.50.0/24", "10.230.150.0/24"]
    testdev_02_subnet       = ["10.230.60.0/24", "10.230.160.0/24"]    
    
    azs_2                   = ["ap-southeast-1a", "ap-southeast-1c"]
    azs_4                   = ["ap-southeast-1a", "ap-southeast-1c",  "ap-southeast-1a", "ap-southeast-1c"]
    az_ac                   = ["a", "c"]
    az_ac_4                 = ["a", "c", "a", "c"]

    user_dev_vpc            = tolist(slice(aws_vpc.project_vpc[*].id, 0, 2))
    prod_test_vpc           = tolist(slice(aws_vpc.project_vpc[*].id, 3, 5))

    user_pub_sub            = tolist(slice(aws_subnet.subnet_user_dmz_pub[*].id, 0, 2))
    dev_pub_sub             = tolist(slice(aws_subnet.subnet_dev_dmz_pub[*].id, 0, 2))

    user_eip                = tolist(slice(aws_eip.dmz_eip[*].id, 0, 2))
    dev_eip                 = tolist(slice(aws_eip.dmz_eip[*].id, 2, 4))

    user_dev_tgw_rt           = tolist(slice(data.aws_ec2_transit_gateway_vpc_attachment.shared_tgw_rt[*], 0, 2))
    prod_test_tgw_rt          = tolist(slice(data.aws_ec2_transit_gateway_vpc_attachment.shared_tgw_rt[*], 3, 5))
        
    dmz_lb_ports            = [8888, 9999]
    dmz_proxy_ports         = [80, 9009, 22]             
    shared_int_ports        = [1111, 2222, 3333, 4444]               
    prodtest_lb_ports       = [6666, 7777]             
    product_int_ports       = [1001, 2002, 3003, 4004]             
    testdev_int_ports       = [5005, 6006, 7007, 8008]

    shared_ec2_name         = ["prometheus", "grafana", "elk", "eks"]
    prodtest_ec2_name       = ["node-1", "node-2", "rds-primary", "rds-stanby"]

    userdev_rt_name         = ["nat", "nat", "lb", "lb", "proxy"]
    shared_rt_name          = ["nexus", "control"]
    prodtest_rt_name        = ["node", "rds"]
    #cf_origin_name          = ["user_dmz_lb_a", "user_dmz_lb_c", "user_dmz_group"]

    domain_name             = "nadri-project.com"
    host_zone               = "Z0373230225TMW4PZYVS1"
    weight                  = [200, 100]


}