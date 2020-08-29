#!/bin/sh
set -eu

CLUSTER=$1
SERVICE=${2:-$CLUSTER}

green "Deploying ECS cluster..."
blue "Cluster Name: ${CLUSTER}"
blue "Service Name: ${SERVICE}"

aws ecs update-service --cluster $CLUSTER --service $SERVICE --force-new-deployment