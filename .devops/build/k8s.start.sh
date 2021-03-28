#!/bin/bash

echo "Creating nodebb config.json from envs..."
envsubst < /opt/nodebb/k8s.config.json.template > /opt/nodebb/config.json || (echo "Unable to create nodebb config.json" && exit 1)

# echo "Upgrading nodebb..."
# ./nodebb upgrade

echo "Starting nodebb..."
node ./nodebb start
