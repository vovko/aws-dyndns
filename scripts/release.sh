#!/usr/bin/env bash

set -euxo pipefail

APP_NAME=${APP_NAME:-dns_update}
AWS_REGION=${AWS_REGION:-us-east-1}
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
REGISTRY_URL="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Build
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REGISTRY_URL"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
docker build -t "$APP_NAME" "$DIR/.."

# Push to ECR
REPO_URL="$REGISTRY_URL/$APP_NAME:latest"
docker tag "$APP_NAME:latest" "$REPO_URL"
docker push "$REPO_URL"

# Output
echo "https://console.aws.amazon.com/ecr/repositories/$APP_NAME/?region=$AWS_REGION"