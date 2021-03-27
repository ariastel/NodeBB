#!/bin/bash

docker build \
  --build-arg NODE_ENV=production \
  -t nodebb-frontend \
  -f .devops/build/frontend.Dockerfile \
  .
