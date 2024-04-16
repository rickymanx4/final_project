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

    user_dev_vpc            = tolist(slice(aws_vpc.project_vpc[*].id, 0, 2))
    prod_test_vpc           = tolist(slice(aws_vpc.project_vpc[*].id, 3, 5))

    user_pub_sub            = tolist(slice(aws_subnet.subnet_user_dmz_pub[*].id, 0, 2))
    dev_pub_sub             = tolist(slice(aws_subnet.subnet_dev_dmz_pub[*].id, 0, 2))

    user_eip                = tolist(slice(aws_eip.dmz_eip[*].id, 0, 2))
    dev_eip                 = tolist(slice(aws_eip.dmz_eip[*].id, 2, 4))

    shared_tgw_rt           = tolist(data.aws_ec2_transit_gateway_vpc_attachment.shared_tgw_rt)
    # shared_control_a        = tolist(data.aws_instance.shared_tg_att_a)
    # shared_control_c        = tolist(data.aws_instance.shared_tg_att_c)    
    
    shared_ports            = [1111, 2222, 3333, 4444]             
    shared_ec2_name         = ["prometheus", "grafana", "elk"]

}