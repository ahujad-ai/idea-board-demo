#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh <gcp|aws>"
  exit 1
fi
CLOUD=$1
TF_DIR="terraform/$CLOUD"
if [ ! -d "$TF_DIR" ]; then
  echo "Terraform dir $TF_DIR not found!"
  exit 1
fi
# user should copy terraform.tfvars into the cloud dir or export env vars
cd "$TF_DIR"
echo "Running terraform init in $TF_DIR..."
terraform init
echo "Running terraform apply in $TF_DIR..."
terraform apply -auto-approve
echo "Terraform apply complete for $CLOUD"
