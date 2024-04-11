# ami 만드는 것
resource "aws_ami_from_instance" "ami_web" {
  name               = "Web_AMI"
  source_instance_id = aws_instance.project_web.id
  depends_on = [
    null_resource.delete_service_bastion,
    null_resource.install_monitoring
  ]
}
resource "aws_ami_from_instance" "ami_app" {
  name               = "APP_AMI"
  source_instance_id = aws_instance.project_app.id
  depends_on = [
    null_resource.delete_service_bastion,
    null_resource.install_monitoring
  ]
}