FROM docker:19.03.8

# See: https://about.gitlab.com/releases/2019/07/31/docker-in-docker-with-docker-19-dot-03/
ENV DOCKER_DRIVER="overlay2"
ENV DOCKER_TLS_CERTDIR=""

# Pin versions installed
# ----------------------
# Terraform: https://github.com/hashicorp/terraform/tags
# Gomplate:  https://github.com/hairyhenderson/gomplate/releases
# AWS CLI:   https://github.com/aws/aws-cli/releases
ARG TERRAFORM_VERSION="0.13.1"
ARG GOMPLATE_VERSION="3.7.0"
ARG AWS_CLI_VERSION="2.0.42"
ARG JQ_VERSION="1.6"

# Install CLI color helper scripts
COPY colors.sh .
RUN source colors.sh && \
    green "Let there be color!" && \
    green_bold "Let there be color!" && \
    blue "Let there be color!" && \
    blue_bold "Let there be color!" && \
    red "Let there be color!"

# Install Git, bash, and other common libraries
RUN apk --no-cache add git bash unzip go curl



# Install AWS CLI (V2)
#  - This is not officially supported on Alpine so there is some extra complexity
#    See: https://stackoverflow.com/a/61268529/1356593 🥳
ENV GLIBC_VER=2.31-r0
RUN blue "Installing AWS CLI (${AWS_CLI_VERSION})" \
    && apk --no-cache add binutils \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

# Install Gomplate tool - https://docs.gomplate.ca
RUN blue "Installing gomplate (${GOMPLATE_VERSION})" && \
    curl -o /usr/local/bin/gomplate -sSL "https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64" && \
    chmod 755 /usr/local/bin/gomplate

# Install Terraform
ENV GOPATH=/usr/local
RUN blue "Installing Terraform (${TERRAFORM_VERSION})" && \
    cd /tmp && \
    git clone --depth 1 --branch "v${TERRAFORM_VERSION}" https://github.com/hashicorp/terraform.git && \
    cd terraform && \
    go install

RUN blue "Installing jq (${JQ_VERSION})" && \
    curl -o /usr/local/bin/jq -sSL "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
    chmod 755 /usr/local/bin/jq

# Install helper script for deploying a cluster and service in ECR
COPY aws-ecs-deploy.sh /usr/local/bin/aws-ecs-deploy

# Install the environment selector helper script
COPY aws-env-set.sh /usr/local/bin/aws-env-set