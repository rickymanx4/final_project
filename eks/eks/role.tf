###
# 1. cluster role
###
resource "aws_iam_role" "was-cluster" { 
  name               = "eks-cluster-was"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json 
} 
resource "aws_iam_role_policy_attachment" "was-AmazonEKSClusterPolicy" { 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" 
  role       = aws_iam_role.was-cluster.name 
} 
# Optionally, enable Security Groups for Pods 
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html 
resource "aws_iam_role_policy_attachment" "was-AmazonEKSVPCResourceController" { 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController" 
  role       = aws_iam_role.was-cluster.name 
} 
###
# 2. node role
###
resource "aws_iam_role" "was-node" { 
  name = "eks-node-was" 
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
} 
resource "aws_iam_role_policy_attachment" "was-AmazonEKSWorkerNodePolicy" { 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" 
  role       = aws_iam_role.was-node.name 
} 
resource "aws_iam_role_policy_attachment" "was-AmazonEKS_CNI_Policy" { 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" 
  role       = aws_iam_role.was-node.name 
} 
resource "aws_iam_role_policy_attachment" "was-AmazonEC2ContainerRegistryReadOnly" { 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" 
  role       = aws_iam_role.was-node.name 
} 
resource "aws_iam_role_policy_attachment" "was-CloudWatchAgentServerPolicy" { 
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" 
  role       = aws_iam_role.was-node.name 
}