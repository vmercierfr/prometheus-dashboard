#!/bin/bash

set -e

# Get app facts
echo "- Get APP facts..."
DOCKER_IMAGE=vmercier/prometheus-dashboard
BUILD_DATE=$(date +%Y-%m-%dT%T%z)
#BUILD_VERSION=$(docker-compose run app python -c 'from phonebook import app;print(app.VERSION, end="")')
BUILD_VERSION=0.1
VCS_REF=$(git rev-parse HEAD)

# Run unittests
#echo "- Running unittests..."
#docker-compose run app python app_tests.py

# Build Docker container
echo "- Build Docker container..."
docker build \
    --build-arg VCS_REF=${VCS_REF} \
    --build-arg BUILD_DATE=${BUILD_DATE} \
    --build-arg BUILD_VERSION=${BUILD_VERSION} \
    -t $DOCKER_IMAGE:$BUILD_VERSION \
    .

# Push docker container to Dockerhub registry
echo "- Push image to Dockerhub..."
docker push $DOCKER_IMAGE:$BUILD_VERSION

echo "- Done!"