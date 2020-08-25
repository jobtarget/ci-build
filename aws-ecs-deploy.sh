#!/bin/sh
set -eu

CLUSTER=$1
SERVICE=$1
if [ -n "$2" ]; then
  SERVICE=$2
fi

green "Cluster Name: ${CLUSTER}"
green "Service Name: ${SERVICE}"

aws ecs update-service --cluster $CLUSTER --service $SERVICE --force-new-deployment