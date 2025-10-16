#!/bin/bash
set -e

echo "Building Docker image..."
docker build -t Docker:latest .

echo "Build completed successfully!"