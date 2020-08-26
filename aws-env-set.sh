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
    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_PROD
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PROD
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PROD
    export AWS_ECR_HOST=$AWS_ECR_HOST_PROD
    green "Using production AWS credentials."
    ;;
  uat|UAT|staging|Staging|stg|qa|QA|dev|development|Development|Dev|DEV)
    # Use the _DEV version of credentials stored as CI variables in GitLab
    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_DEV
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_DEV
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_DEV
    export AWS_ECR_HOST=$AWS_ECR_HOST_DEV
    green "Using development AWS credentials."
    ;;
  *)
    red "Unknown environment. 😱  You're on your own..."
    ;;
esac