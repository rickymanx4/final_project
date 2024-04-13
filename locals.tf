locals {
    tgw_name                = "final-vpc-tgw"
    # user_dmz_name           = "user_dmz"
    # dev_dmz_name            = "dev_dmz"
    # shared_name             = "shared"
    # product_name            = "product"
    # testdev_name            = "testdev"
    names                   = ["user_dmz", "dev_dmz", "shared", "product", "testdev"]
   
    region                  = "ap-southeast-1"

    user_dmz_vpc_cidr       = "10.10.0.0/16"
    dev_dmz_vpc_cidr        = "10.30.0.0/16"
    shared_vpc_cidr         = "10.100.0.0/16"
    prod_vpc_cidr           = "10.210.0.0/16"
    testdev_vpc_cidr        = "10.230.0.0/16"
    

    user_dmz_pub_subnet     = ["10.10.10.0/24", "10.10.20.0/24", "10.10.110.0/24", "10.10.120.0/24"]
    user_dmz_pri_subnet     = ["10.10.50.0/24", "10.10.50.0/24"]
    dev_dmz_pub_subnet      = ["10.30.10.0/24", "10.30.20.0/24", "10.30.110.0/24", "10.30.120.0/24"]
    dev_dmz_pri_subnet      = ["10.30.50.0/24", "10.30.50.0/24"]    
    shared_pri_subnet       = ["10.100.50.0/24","10.100.50.0/24"]  
    product_01_subnet       = ["10.210.50.0/24", "10.210.150.0/24"]
    product_02_subnet       = ["10.210.60.0/24", "10.210.160.0/24"]    
    testdev_01_subnet       = ["10.230.50.0/24", "10.230.150.0/24"]
    testdev_02_subnet       = ["10.230.60.0/24", "10.230.160.0/24"]    
    
    azs_2                   = ["ap-southeast-1a", "ap-southeast-1c"]
    azs_4                   = ["ap-southeast-1a", "ap-southeast-1a", "ap-southeast-1c", "ap-southeast-1c"]
    az_ac                   = ["a", "c"]


}