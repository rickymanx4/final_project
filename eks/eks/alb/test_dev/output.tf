###
# 1. pod security group ids
###
output "test_dev_pod_sg" {
    value = data.aws_security_group.test_dev_pod_security_group.id
}
output "prod_pod_sg" {
    value = data.aws_security_group.prod_pod_security_group.id
}