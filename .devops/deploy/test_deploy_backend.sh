#!/bin/bash

cd ./.devops/deploy/helm

helm upgrade nodebb \
  -n local \
  -f values-local.yaml \
  --install \
  .
