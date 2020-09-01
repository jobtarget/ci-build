#!/bin/sh
set -eu

# CI_ENVIRONMENT_NAME is set by GitLab CI on deploy jobs only
ENV=${1:-$CI_ENVIRONMENT_NAME}

blue "🤞 Attempting to connect to AWS deployment environment labeled '${ENV}'..."

# Convert $ENV to lowercase
ENV=$(echo "{{strings.ToLower \"${ENV}\"}}" | gomplate);

# Filter the JSON-formatted $AWS_ENV_JSON to select the values of our targeted account
AWS_ACCT_ALIAS=$(echo $AWS_ENV_JSON           | jq -r ".${ENV}")

blue "Using account config for '${AWS_ACCT_ALIAS}'"

green "👀 Extracting configuration information from \$AWS_CONFIG_JSON..."
# Select the specific account details into variables
AWS_DEFAULT_REGION=$(echo $AWS_CONFIG_JSON    | jq -r ".${AWS_ACCT_ALIAS} .default_region")
AWS_ACCOUNT_ID=$(echo $AWS_CONFIG_JSON        | jq -r ".${AWS_ACCT_ALIAS} .aws_account_id")
AWS_ACCESS_KEY_ID=$(echo $AWS_CONFIG_JSON     | jq -r ".${AWS_ACCT_ALIAS} .aws_access_key_id")
AWS_SECRET_ACCESS_KEY=$(echo $AWS_CONFIG_JSON | jq -r ".${AWS_ACCT_ALIAS} .aws_secret_access_key")
AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"

# Authenticate the AWS CLI
green "📇 Registering access credentials with AWS CLI..."
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

green "🤝 Authenticating Docker with ECR..."
aws ecr get-login-password --region $AWS_DEFAULT_REGION | \
    docker login --username AWS --password-stdin $AWS_ECR_URL

green "💾 Saving select config values to: ~/.aws-env.json"
echo "{\"ecr_repo\":\"${AWS_ECR_URL}\"}" > ~/.aws-env.json