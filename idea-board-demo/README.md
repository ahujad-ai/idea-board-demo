# Cloud-Agnostic Terraform Repo (AWS + GCP)

This Terraform repo can deploy the same stack to **AWS** or **GCP** by changing a single variable `cloud`.

Stack includes:
- VPC / Network
- Kubernetes cluster (GKE on GCP, EKS on AWS)
- PostgreSQL DB (Cloud SQL on GCP, RDS on AWS)
- Dockerized backend + frontend apps

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and edit values.
2. Initialize Terraform: `terraform init`
3. Plan: `terraform plan -var-file="terraform.tfvars"`
4. Apply: `terraform apply -var-file="terraform.tfvars" -auto-approve`
5. Use `terraform output` to get `kubeconfig` and DB connection info
6. Deploy Kubernetes manifests using `kubectl`.
