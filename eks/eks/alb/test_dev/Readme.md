### terraform 설치
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf repolist 
sudo dnf install terraform -y 
sudo yum --showduplicate list terraform 
sudo rpm -qa | grep terraform 
sudo terraform version
###
https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/private-clusters.html
### kubectl 설치
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp kubectl /usr/bin/
sudo rm -rf kubectl
kubectl version --client
### eksctl 설치 (필요시)
https://docs.aws.amazon.com/ko_kr/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-eksctl.html
###
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
### eksctl completion
eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh 
. ~/.bash_completion 
bash
###
aws eks update-kubeconfig --name test_dev_was
kubectl get nodes -o wide
kubectl get pods,svc,ingress -A
kubectl get endpoints -A
###
https://aws-ia.github.io/terraform-aws-eks-blueprints/patterns/fully-private-cluster/
### alb log check
kubectl logs -f -n kube-system -l app.kubernetes.io/instance=aws-load-balancer-controller

###
현재 node-exporter.tf 가 실행 되어도 ingress 안 만들어짐
방법을 찾아볼 것
https://artifacthub.io/packages/helm/bitnami/node-exporter

### pod security group
https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/security-groups-for-pods.html
https://medium.com/@seifeddinerajhi/aws-eks-security-groups-per-pod-improve-the-security-of-your-kubernetes-clusters-a23a961793dc
###
Amazon VPC CNI plugin for Kubernetes 버전 확인
kubectl describe daemonset aws-node --namespace kube-system | grep amazon-k8s-cni: | cut -d : -f 3
1.7.7 이상 필요
