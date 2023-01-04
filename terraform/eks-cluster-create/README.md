This repository consists of tf files which creates an EKS cluster. Cluster creation was tested using v1.3.6

Variables that can be changed: 
- AWS Region
- Cluster name
- VPC CIDR

<ins>**Prerequisites:**</ins>
- Terraform
- aws iam authenticator
- aws cli configured

<ins>**Usage:**</ins>

```sh 

terraform init

terraform plan

terraform apply --auto-approve

```

Once the cluster is created, run below command to get access to the EKS cluster using kubectl 

terraform output -raw kubeconfig > ~/.kube/config 
