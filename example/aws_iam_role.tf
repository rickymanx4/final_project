####################################
# 1. create iam role
####################################
resource "aws_iam_role" "blind_bastion_role" {
  name               = "sk104-003-bastion-cloudwatch-terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
     }
   ]
  }
  EOF
}
resource "aws_iam_role" "testbed_cloudwatch_role" {
  name               = "sk104-003-testbed-cloudwatch-terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
     }
   ]
  }
  EOF
}

####################################
# 2.Create Policy
####################################
resource "aws_iam_policy" "bind_ec2_policy" {
  name        = "blind_ec2_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

####################################
# 3. policy attachment on role
####################################
resource "aws_iam_policy_attachment" "blind_bastion_ec2_policy" {
  name       = "AmazonEC2RoleforSSM-Attachment"
  roles      = [aws_iam_role.blind_bastion_role.name]
  policy_arn = aws_iam_policy.bind_ec2_policy.arn
}
resource "aws_iam_policy_attachment" "attach_amazonec2_policy" {
  name       = "AmazonEC2RoleforSSM-Attachment"
  roles      = [aws_iam_role.testbed_cloudwatch_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_policy_attachment" "attach_cloudwatch_policy" {
  name       = "CloudWatchAgentServerPolicy-Attachment"
  roles      = [aws_iam_role.testbed_cloudwatch_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

####################################
# 4. IAM 역할을 인스턴스 프로필에 할당
####################################
resource "aws_iam_instance_profile" "blind_bastion_profile" {
  name = "blind_bastion-profile"
  role = aws_iam_role.blind_bastion_role.name
}
resource "aws_iam_instance_profile" "testbed_cloudwatch_profile" {
  name = "testbed-cloudwatch-profile"
  role = aws_iam_role.testbed_cloudwatch_role.name
}
