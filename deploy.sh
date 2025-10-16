#!/bin/bash
set -e

echo "Deploying application..."
docker run -d -p 5000:5000 --name my-running-app Docker:latest

echo "Application deployed successfully!"
echo "Check: http://localhost:5000"