###
# 1. test_dev_was
###
data "aws_vpc" "test_dev_vpc" {
    filter {
        name   = "tag:Name"
        values = ["test-dev"]
    }
}
data "aws_eks_cluster" "test_dev_was" {
    name = "test_dev_was"
}
data "aws_eks_cluster_auth" "test_dev_was" { 
    name = "test_dev_was" 
}
data "tls_certificate" "test_dev_was" { 
    url = data.aws_eks_cluster.test_dev_was.identity[0].oidc[0].issuer 
}
data "aws_iam_openid_connect_provider" "test_dev_was" {
    url = data.aws_eks_cluster.test_dev_was.identity[0].oidc[0].issuer 
}
###
# 2. role
###
data "http" "iam_policy" { 
    url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.1/docs/install/iam_policy.json"
}
###
# 3. security group
###
data "aws_security_group" "test_dev_pod_security_group" {
    filter {
      name = "tag:Name"
      values = ["test_dev_pod_db_sg"]
    }
}
data "aws_security_group" "prod_pod_security_group" {
    filter {
      name = "tag:Name"
      values = ["prod_pod_db_sg"]
    }
}