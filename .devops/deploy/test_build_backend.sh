#!/bin/bash

docker build \
  --build-arg GITHUB_TOKEN="CHANGE_ME_NOW" \
  --build-arg NODE_ENV=production \
  --build-arg NODEBB_SECRET="CTsNDeHNHX9jBnQFgz9WbqkhsQaA24vj" \
  --build-arg NODEBB_URL="https://ritotalks.ru" \
  --build-arg NODEBB_PORT="4567" \
  --build-arg MONGO_HOST="mongodb-production-headless.production.svc.cluster.local" \
  --build-arg MONGO_PORT="27017" \
  --build-arg MONGO_USER="nodebb" \
  --build-arg MONGO_PASS="awesomepassword1" \
  --build-arg MONGO_DATABASE="nodebb" \
  -t nodebb-backend:release \
  -f .devops/build/backend.Dockerfile \
  .
