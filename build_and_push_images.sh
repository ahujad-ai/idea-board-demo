#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./build_and_push_images.sh <gcp|aws> [BACKEND_API_IP] [PROJECT_ID_OR_AWS_ACCOUNT]"
  exit 1
fi

CLOUD=$1
API_IP=$2
IDENT=$3

# Prompt for backend IP if missing
if [ -z "$API_IP" ]; then
  read -p "Enter Backend API IP (e.g., 35.244.29.171): " API_IP
fi

# Ensure buildx is set up
docker buildx create --use >/dev/null 2>&1 || true

echo "🌍 Target Cloud: $CLOUD"
echo "🔗 Backend API IP: $API_IP"

# ---- BUILD AND PUSH IMAGES ----
echo "🚀 Building and pushing backend image..."
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-backend:latest \
  ./backend --push

echo "🚀 Building and pushing frontend image with API URL: http://$API_IP:8000"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-frontend:latest \
  --build-arg VITE_API_URL=http://$API_IP:8000 \
  ./frontend --push

# ---- CLOUD-SPECIFIC LOGIN ----
if [ "$CLOUD" == "gcp" ]; then
  PROJECT_ID=${IDENT:-$(gcloud config get-value project)}
  echo "🔑 Authenticating to GCP Artifact Registry for project: $PROJECT_ID"
  gcloud auth configure-docker asia-south1-docker.pkg.dev --quiet

elif [ "$CLOUD" == "aws" ]; then
  AWS_ACCOUNT=${IDENT:-$(aws sts get-caller-identity --query Account --output text)}
  REGION=$(aws configure get region || echo "ap-south-1")
  echo "🔑 Authenticating to AWS ECR: ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"

  aws ecr describe-repositories --repository-names idea-board --region $REGION >/dev/null 2>&1 || \
    aws ecr create-repository --repository-name idea-board --region $REGION

  aws ecr get-login-password --region $REGION | \
    docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

  docker tag asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-backend:latest \
    ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/idea-board:backend
  docker tag asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-frontend:latest \
    ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/idea-board:frontend

  docker push ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/idea-board:backend
  docker push ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/idea-board:frontend
else
  echo "❌ Unknown cloud '$CLOUD'. Use gcp or aws."
  exit 1
fi

echo "✅ Images built and pushed successfully for $CLOUD"
