# Docker CI Tools

This Docker image is intended to support the building of other Docker images inside a
CI/CD pipeline.  This image is based off of the official Docker image and provides
these additional tools:

| Tool            | Version | Use                                       |
|-----------------|---------|-------------------------------------------|
| [Docker][4]     | 19.0.3  | Containerization engine.                  |
| [AWS CLI][1]    | 2.0.42  | Interacting with AWS.                     |
| [gomplate][2]   | 3.7.0   | A templating tool (written in go)         |
| [Terraform][3]  | 0.13.1  | Infrastructure as code tool.              |


## AWS Convenience Scripts
Out of sheer laziness, we have supplied a few convenience tools that help turn some common AWS CLI tasks into simple-to-remember one-liners.

### `aws-ecr-login`
Logs you into the ECR registry you specify.

```bash
$: aws-ecr-login <ecr.repository.host>
```

### `aws-ecs-deploy`
Forces an ECS service to deploy.  If you don't specify a service name, the cluster name is assumed to match the service name by convention.

```bash
$: aws-ecs-deploy "cluster-name" ["service-name"]
```

[1]:https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
[2]:https://docs.gomplate.ca
[3]:https://www.terraform.io
[4]:https://www.docker.com/get-started