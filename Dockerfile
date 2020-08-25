FROM docker:19.03.8

# See: https://github.com/hashicorp/terraform/tags
ARG TERRAFORM_VERSION="v0.13.0"

# Install Git and bash
RUN apk add --no-cache git bash unzip go



# Install AWS CLI (V2)
#  - This is not officially supported on Alpine so there is some extra complexity
#    See: https://stackoverflow.com/a/61268529/1356593 🥳
ENV GLIBC_VER=2.31-r0
RUN apk --no-cache add \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
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
        curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*



# Install Gomplate tool - https://docs.gomplate.ca
RUN apk add --no-cache gomplate

# Install CLI color helper scripts
COPY colors.sh .
RUN source colors.sh && \
    green "Let there be color!" && \
    green_bold "Let there be color!" && \
    blue "Let there be color!" && \
    blue_bold "Let there be color!" && \
    red "Let there be color!"

# Insall helper script for logging into ECR
COPY aws-ecr-login.sh /usr/local/bin/aws-ecr-login

# Install helper script for deploying a cluster and service in ECR
COPY aws-ecs-deploy.sh /usr/local/bin/aws-ecs-deploy

ENV GOPATH=/usr/local
RUN cd /tmp && \
    git clone --depth 1 --branch $TERRAFORM_VERSION https://github.com/hashicorp/terraform.git && \
    cd terraform && \
    go install