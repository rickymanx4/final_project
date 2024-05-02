### terraform 설치
sudo yum install -y yum-utils
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
aws eks update-kubeconfig --name prod_was
kubectl get pods,svc,ingress -A
kubectl get nodes -o wide
kubectl get endpoints -A
###
https://aws-ia.github.io/terraform-aws-eks-blueprints/patterns/fully-private-cluster/
### alb log check
kubectl logs -f -n kube-system -l app.kubernetes.io/instance=aws-load-balancer-controller