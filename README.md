# Docker CI Tools

This Docker image is intended to support the building of other Docker images inside a
CI/CD pipeline.  This image is based off of the official Docker image and provides
these additional tools:

| Tool            | Version | Use                                       |
|-----------------|---------|-------------------------------------------|
| [Docker][4]     | 19.0.3  | Containerization engine.                  |
| [AWS CLI][1]    | 2.0.42  | Interacting with AWS.                     |
| [gomplate][2]   | 3.7.0   | A templating tool (written in go)         |
| [Terraform][3]  | 0.13.0  | Infrastructure as code tool.              |


[1]:https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
[2]:https://docs.gomplate.ca
[3]:https://www.terraform.io