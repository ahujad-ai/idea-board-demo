#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "Usage: ./build_and_push_images.sh <gcp|aws> <PROJECT_ID_OR_AWS_ACCOUNT(optional)>"
  exit 1
fi
CLOUD=$1
IDENT=$3
API_IP=$2

if [ -z "$API_IP" ]; then
  read -p "Enter Backend API IP (e.g., 35.244.29.171): " API_IP
fi

echo "🚀 Building backend image..."
docker buildx build \
  --platform linux/amd64 \
  -t asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-backend:latest \
  ./backend --push

# Build frontend
echo "🚀 Building frontend image with API URL: http://$API_IP:8000"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t asia-south1-docker.pkg.dev/outmarket-ai-demo/idea-board/idea-frontend:latest \
  --build-arg VITE_API_URL=http://$API_IP:8000 \
  ./frontend --push

if [ "$CLOUD" == "gcp" ]; then
  if [ -z "$IDENT" ]; then
    PROJECT_ID=$(gcloud config get-value project)
  else
    PROJECT_ID=$IDENT
  fi
  gcloud auth configure-docker asia-south1-docker.pkg.dev
  docker tag idea-backend:latest asia-south1-docker.pkg.dev/${PROJECT_ID}/idea-board/idea-backend:latest
  docker tag idea-frontend:latest asia-south1-docker.pkg.dev/${PROJECT_ID}/idea-board/idea-frontend:latest
  docker push asia-south1-docker.pkg.dev/${PROJECT_ID}/idea-board/idea-backend:latest
  docker push asia-south1-docker.pkg.dev/${PROJECT_ID}/idea-board/idea-frontend:latest
elif [ "$CLOUD" == "aws" ]; then
  if [ -z "$IDENT" ]; then
    AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
  else
    AWS_ACCOUNT=$IDENT
  fi
  REGION=$(aws configure get region || echo ap-south-1)
  aws ecr create-repository --repository-name idea-board || true
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.$REGION.amazonaws.com
  docker tag idea-backend:latest ${AWS_ACCOUNT}.dkr.ecr.$REGION.amazonaws.com/idea-board:latest
  docker tag idea-frontend:latest ${AWS_ACCOUNT}.dkr.ecr.$REGION.amazonaws.com/idea-board:latest
  docker push ${AWS_ACCOUNT}.dkr.ecr.$REGION.amazonaws.com/idea-board:latest
else
  echo "Unknown cloud $CLOUD"
  exit 1
fi
echo "Images pushed for $CLOUD"
