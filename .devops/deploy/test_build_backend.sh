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
  --build-arg REDIS_HOST="ritotalks-production-001.some_thing.0001.euc1.cache.amazonaws.com" \
  --build-arg REDIS_PORT="6379" \
  --build-arg REDIS_DATABASE="0" \
  -t nodebb-backend:release \
  -f .devops/build/backend.Dockerfile \
  .
