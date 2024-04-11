####################################
# EFS 파일 시스템 생성
####################################
resource "aws_efs_file_system" "web_efs" {
  creation_token = "web_efs"
  # one zone class를 이용할 경우
  # availability_zone_name = "us-west-2a"

  # 유휴 시 데이터 암호화
  encrypted = true
  # KMS에서 관리형 키를 이용하려면 kms_key_id 속성을 붙여줍니다.

  # 성능 모드: generalPurpose(범용 모드), maxIO(최대 IO 모드)
  performance_mode = "generalPurpose"

  # 버스팅 처리량 모드
  throughput_mode = "bursting"

  # 프로비저닝 처리량 모드
  # throughput_mode = "provisioned"
  # provisioned_throughput_in_mibps = 100

  # 수명 주기 관리
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "Web_EFS"
  }
}
resource "aws_efs_file_system" "app_efs" {
  creation_token = "app_efs"

  encrypted = true

  performance_mode = "generalPurpose"

  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "APP_EFS"
  }
}
####################################
# 표준 클래스로 EFS를 생성하더라도 탑재 대상은 모든 가용영역에 수동으로 지정해주어야 합니다.
####################################
resource "aws_efs_mount_target" "web_mount" {
    count = length(var.web_subnet)
    file_system_id  = aws_efs_file_system.web_efs.id
    subnet_id       = element(aws_subnet.web[*].id, count.index)
    security_groups = [aws_security_group.project_web_efs.id]
}

resource "aws_efs_mount_target" "app_mount" {
    count = length(var.app_subnet)
    file_system_id  = aws_efs_file_system.app_efs.id
    subnet_id      = element(aws_subnet.app[*].id, count.index)
    security_groups = [aws_security_group.project_app_efs.id]
}