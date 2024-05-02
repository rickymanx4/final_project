###
# 1. test develope relem
###
resource "aws_eks_cluster" "test_dev_was" { 
  name     = "test_dev_was"
  role_arn = aws_iam_role.was-cluster.arn 
  vpc_config { 
    subnet_ids              = data.aws_subnets.test_dev_node.ids
    security_group_ids      = data.aws_security_groups.test_dev_cluster.ids
    endpoint_private_access = true
    endpoint_public_access  = false
  } 
 
# Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling. 
# Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups. 

  depends_on = [ 
    aws_iam_role_policy_attachment.was-AmazonEKSClusterPolicy, 
    aws_iam_role_policy_attachment.was-AmazonEKSVPCResourceController, 
    aws_cloudwatch_log_group.test_dev_was 
  ] 
  enabled_cluster_log_types = ["api", "audit"] 
} 
resource "aws_cloudwatch_log_group" "test_dev_was" { 
  name              = "/aws/eks/test_dev_was/cluster" 
  retention_in_days = 7 
} 
data "tls_certificate" "test_dev_was" { 
  url = aws_eks_cluster.test_dev_was.identity[0].oidc[0].issuer 
}
resource "aws_iam_openid_connect_provider" "test_dev_was" { 
  client_id_list  = ["sts.amazonaws.com"] 
  thumbprint_list = [data.tls_certificate.test_dev_was.certificates[0].sha1_fingerprint] 
  url             = data.tls_certificate.test_dev_was.url 
}
###
# 2. production relem
###
resource "aws_eks_cluster" "prod_was" { 
  name     = "prod_was"
  role_arn = aws_iam_role.was-cluster.arn 
  vpc_config { 
    subnet_ids              = data.aws_subnets.prod_node.ids
    security_group_ids      = data.aws_security_groups.prod_cluster.ids
    endpoint_private_access = true
    endpoint_public_access  = false
  } 
 
# Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling. 
# Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups. 

  depends_on = [ 
    aws_iam_role_policy_attachment.was-AmazonEKSClusterPolicy, 
    aws_iam_role_policy_attachment.was-AmazonEKSVPCResourceController, 
    aws_cloudwatch_log_group.prod_was 
  ] 
  enabled_cluster_log_types = ["api", "audit"] 
} 
resource "aws_cloudwatch_log_group" "prod_was" { 
  name              = "/aws/eks/prod_was/cluster" 
  retention_in_days = 7 
} 
data "tls_certificate" "prod_was" { 
  url = aws_eks_cluster.prod_was.identity[0].oidc[0].issuer 
}
resource "aws_iam_openid_connect_provider" "prod_was" { 
  client_id_list  = ["sts.amazonaws.com"] 
  thumbprint_list = [data.tls_certificate.prod_was.certificates[0].sha1_fingerprint] 
  url             = data.tls_certificate.prod_was.url 
}