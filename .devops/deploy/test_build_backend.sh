#!/bin/bash

docker build \
  --build-arg GITHUB_TOKEN="12345" \
  --build-arg NODE_ENV="production" \
  --build-arg NODEBB_SECRET="CTsNDeHNHX9jBnQFgz9WbqkhsQaA24vj" \
  --build-arg NODEBB_URL="http://ritotalks.ru" \
  --build-arg NODEBB_PORT="8080" \
  --build-arg MONGO_HOST="mongodb-headless.production.svc.cluster.local" \
  --build-arg MONGO_PORT="27017" \
  --build-arg MONGO_USER="nodebb" \
  --build-arg MONGO_PASS="awesomepassword1" \
  --build-arg MONGO_DATABASE="nodebb" \
  -t nodebb-backend:release \
  -f .devops/build/backend.Dockerfile \
  .
