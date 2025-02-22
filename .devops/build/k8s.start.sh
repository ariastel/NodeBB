#!/bin/bash

echo "Creating nodebb config.json from envs..."
envsubst < /opt/nodebb/k8s.config.json.template > /opt/nodebb/config.json || (echo "Unable to create nodebb config.json" && exit 1)

# Run command below if it's a fresh new install
# ./nodebb setup --skip-build

# Run command below for upgrade
# ./nodebb upgrade

echo "Current nodebb config.json"
cat /opt/nodebb/config.json

echo "Starting nodebb..."
./nodebb start
