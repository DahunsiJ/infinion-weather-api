#!/usr/bin/env bash
set -euo pipefail

# quick local helper to build/push & deploy to AKS
ACR_NAME="${ACR_NAME:-infinionwhacr001}"
IMAGE_NAME="infinion-weather-api"
TAG="${TAG:-$(git rev-parse --short HEAD)}"
IMAGE="${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}"

echo "Building image ${IMAGE}..."
docker build -t "${IMAGE}" -f Dockerfile .

echo "Logging in to ACR ${ACR_NAME}..."
az acr login --name "${ACR_NAME}"

echo "Pushing ${IMAGE}..."
docker push "${IMAGE}"

echo "Replace IMAGE_PLACEHOLDER in manifest and apply..."
sed -i.bak "s|IMAGE_PLACEHOLDER|${IMAGE}|g" k8s/deployment.yaml
kubectl apply -f k8s/namespace.yaml || true
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/infinion-weather-api --timeout=120s
echo "Done."
