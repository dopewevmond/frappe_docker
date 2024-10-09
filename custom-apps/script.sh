#!/bin/bash

export APPS_JSON_BASE64=$(base64 -i gitops/apps.json)
echo "Base64 encoding of apps.json"
echo $APPS_JSON_BASE64

source .env
echo $CUSTOM_IMAGE:$CUSTOM_TAG

docker buildx create \
  --name container-builder \
  --driver=docker-container

docker buildx build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=PYTHON_VERSION=3.11.9 \
  --build-arg=NODE_VERSION=18.20.2 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag $CUSTOM_IMAGE:$CUSTOM_TAG \
  --platform linux/amd64 \
  --file=Dockerfile . \
  --builder container-builder \
  --load
