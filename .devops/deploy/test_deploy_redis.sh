#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install redis bitnami/redis \
  -n local

# Create MongoDB a database and add a new user
#
# 1. kubectl run --namespace local redis-client --rm --tty -i --restart='Never' --env REDIS_PASSWORD=$REDIS_PASSWORD --image docker.io/bitnami/redis:6.0.12-debian-10-r3 -- bash
# 2. Connect using the Redis(TM) CLI:
#   redis-cli -h redis-master -a $REDIS_PASSWORD
#   redis-cli -h redis-slave -a $REDIS_PASSWORD
