#!/bin/sh
set -eu

# This script is very customized to our specific use case and not very clever.  The
# aim is to export the correct environment variables for the AWS CLI to be able to
# connect.  We currently use a "dev" account and a "prod" account in AWS.


# This presumes you are running under GitLab
# See: https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
case $CI_ENVIRONMENT_NAME in
  prod|production|Production)
    # Use the _PROD version of credentials stored as CI variables in GitLab
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_PROD
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PROD
    AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION_PROD
    AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID_PROD
    green "Using production AWS credentials."
    ;;
  uat|UAT|staging|Staging|stg|qa|QA|dev|development|Development|Dev|DEV)
    # Use the _DEV version of credentials stored as CI variables in GitLab
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_DEV
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_DEV
    AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION_DEV
    AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID_DEV
    green "Using development AWS credentials."
    ;;
  *)
    red "Unknown environment. 😱  You're on your own..."
    exit 0
    ;;
esac

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION
aws ecr get-login-password --region $AWS_DEFAULT_REGION | \
    docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"