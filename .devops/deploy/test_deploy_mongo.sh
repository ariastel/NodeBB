#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install mongodb bitnami/mongodb \
  -n local \
  --set architecture=replicaset \
  --set auth.enabled=false \
  --set arbiter.enabled=true \
  --set replicaCount=3

# Create MongoDB a database and add a new user
#
# 1. kubectl run --namespace local mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:4.4.4-debian-10-r41 --command -- bash
# 2. mongo admin --host "mongodb-0.mongodb-headless.local.svc.cluster.local:27017,mongodb-1.mongodb-headless.local.svc.cluster.local:27017,mongodb-2.mongodb-headless.local.svc.cluster.local:27017"
