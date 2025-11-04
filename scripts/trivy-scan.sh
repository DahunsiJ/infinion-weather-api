#!/bin/bash
set -e

echo "🧩 Running Trivy security scan..."

# Scan Docker image and filesystem
IMAGE_NAME=${1:-"infinion-weather-api:latest"}
OUTPUT_DIR="$(dirname "$0")/../scans/trivy"

mkdir -p "$OUTPUT_DIR"

echo "🔍 Scanning Docker image..."
trivy image --severity HIGH,CRITICAL --no-progress -f table -o "$OUTPUT_DIR/image-scan.txt" "$IMAGE_NAME"

echo "🔍 Scanning filesystem..."
trivy fs --severity HIGH,CRITICAL --no-progress -f table -o "$OUTPUT_DIR/filesystem-scan.txt" .

echo "✅ Trivy scan completed. Reports saved in $OUTPUT_DIR"
