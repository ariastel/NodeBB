#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install mongodb-production bitnami/mongodb \
  -n production \
  --set architecture=replicaset \
  --set auth.enabled=false \
  --set replicaCount=3 \
  --set arbiter.enabled=true

#
# Create MongoDB database and add a new user
#
# 1. kubectl run --namespace production mongodb-production-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:4.4.4-debian-10-r41 --command -- bash
# 2. mongo admin --host "mongodb-production-0.mongodb-production-headless.production.svc.cluster.local:27017,mongodb-production-1.mongodb-production-headless.production.svc.cluster.local:27017,mongodb-production-2.mongodb-production-headless.production.svc.cluster.local:27017"
#
