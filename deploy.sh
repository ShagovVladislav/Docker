#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-shagovvladislav/docker-demo}"
IMAGE_TAG="${IMAGE_TAG:-local}"

container_name="docker-demo"
docker rm -f "${container_name}" >/dev/null 2>&1 || true

docker run -d --name "${container_name}" -p 5000:5000 \
  --health-cmd='curl -f http://localhost:5000/health || exit 1' \
  --health-interval=30s --health-timeout=3s --health-retries=3 \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "Running: http://localhost:5000"
