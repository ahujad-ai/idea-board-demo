#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh <gcp|aws>"
  exit 1
fi

CLOUD=$1
TF_DIR="terraform/$CLOUD"

if [ ! -d "$TF_DIR" ]; then
  echo "❌ Terraform directory $TF_DIR not found!"
  exit 1
fi

echo "🌍 Selected Cloud Provider: $CLOUD"
echo "📁 Switching to Terraform directory: $TF_DIR"
cd "$TF_DIR"

echo "🚀 Running terraform init..."
terraform init -input=false

echo "⚙️  Applying Terraform infrastructure..."
terraform apply -auto-approve

echo "✅ Terraform apply complete for $CLOUD"
echo "⎈ Getting GKE/EKS credentials..."

if [ "$CLOUD" = "gcp" ]; then
  CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "idea-board-cluster")
  REGION=$(terraform output -raw region 2>/dev/null || echo "asia-south1")
  gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION"
elif [ "$CLOUD" = "aws" ]; then
  CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "idea-board-cluster")
  REGION=$(terraform output -raw region 2>/dev/null || echo "ap-south-1")
  aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"
else
  echo "❌ Unsupported cloud provider: $CLOUD"
  exit 1
fi

echo "✅ Kubernetes credentials configured."
echo "📦 Deploying Kubernetes manifests..."

# Apply backend and frontend manifests
kubectl apply -f ./k8s/gcp/backend.yml
kubectl apply -f ./k8s/gcp/frontend.yml

echo "🎉 Deployment complete!"
kubectl get svc
kubectl get pods
kubectl get ingress
