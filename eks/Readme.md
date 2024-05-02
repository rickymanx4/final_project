# Do not change anything!

##  이용 예상 서비스 및 기능

###  서비스 가용성

- worker node, service pod
    
    prometheus & grafana
    node-exporter - each pods, each instances(?)
    auto scaling group - Dev 로 만든 AMI 를 사용
    AMI 만들기 전 kubernetes worker node 로 attach, node-exporter 설치
    
    backup
    pod image → ECR, quay.io & S3 backup
    worker node → AMI & Launch Templates ( version 관리 )
    
- dynamoDB
    
    이중화
    - Multi-AZ
    aws backup & S3 backup
    
- 보안 로그
    
    S3에 수집 backup
    
- Infra 사업자의 DR
    
    [AWS Elastic Disaster Recovery](https://ap-northeast-2.console.aws.amazon.com/drs/home?region=ap-northeast-2#/welcome)
    

### 네트워크 보안

- 기본 사항
    
    NACL
    Security Group
    Access Control Group
    - Amazon WorkSpace: IP 주소 기반 Access contorl 사용 가능
    - IAM
    
- 네트워크 모니터링
    
    Cloudwatch & SNS
    Prometheus, Node-exporter
    
- 네트워크 정보 보호 시스템
    
    WAF
    AWS Network Firewall
    - IPS, IDS
    Shield - DDos
    
- 네트워크 암호화
    
    ACM
    KMS
    
- 네트워크 분리
    
    VPC peering
    Transit Gateway