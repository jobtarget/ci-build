# Docker CI Tools

This Docker image is intended to support the building of other Docker images inside a CI/CD pipeline (particularly a [GitLab CI][6] pipeline).  This image is based off of the [official Docker image][7] and provides these additional tools:

| Tool            | Version | Use                                       |
|-----------------|---------|-------------------------------------------|
| [Docker][4]     | 19.0.3  | Containerization engine.                  |
| [AWS CLI][1]    | 2.0.42  | Interacting with AWS.                     |
| [gomplate][2]   | 3.7.0   | A templating tool (written in go)         |
| [jq][5]         | 1.6     | Command-line JSON processor.              |
| [Terraform][3]  | 0.13.1  | Infrastructure as code tool.              |


## AWS ECS Deployment
Forces an ECS service to deploy.  If you don't specify a service name, the cluster name is assumed to match the service name by convention.

```bash
$: aws-ecs-deploy "cluster-name" ["service-name"]
```

## AWS CLI Initialization
While you can log into AWS using the CLI via environment variables if you like, it can be annoying to rely on environment variables if you deploy to multiple AWS accounts.  This additional method allows you to select the correct AWS credentials and automatically log in by using 2 different environment variables:

1. `$AWS_ENV_JSON` - This variable is a JSON-encoded object containing all of the different environment names you deploy to and a corresponding AWS account alias.
2. `$AWS_CONFIG_JSON` - This is another JSON-encoded string that contains the different settings for each AWS account.

### Example `$AWS_ENV_JSON`
This is a simple JSON object with name value pairs.  The "name" defaults to GitLab's `$CI_ENVIRONMENT_NAME` [built-in variable][8], but you can provide a manual environment name.

All environment names are converted to lowercase for consistency.  So if you define your [`environment`][9] as "Production", it will be converted to "production" and used as the object key in this JSON lookup.

```json
{
  "prod": "PROD",
  "production": "PROD",
  "uat": "DEV",
  "staging": "DEV",
  "development": "DEV"
}
```

### Example `$AWS_CONFIG_JSON`

```json
{
  "PROD": {
    "aws_access_key_id": "AKACCESSKEYID01234",
    "aws_secret_access_key": "ABCDEFGSECRETACCESSKEY01234",
    "aws_account_id": "0123456789",
    "default_region": "us-east-1"
  },
  "DEV": {
    "aws_access_key_id": "AKACCESSKEYID01234",
    "aws_secret_access_key": "ABCDEFGSECRETACCESSKEY01234",
    "aws_account_id": "0123456789",
    "default_region": "us-east-1"
  }
}
```

[1]:https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
[2]:https://docs.gomplate.ca
[3]:https://www.terraform.io
[4]:https://www.docker.com/get-started
[5]:https://stedolan.github.io/jq/
[6]:https://docs.gitlab.com/ee/ci/
[7]:https://hub.docker.com/_/docker
[8]:https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
[9]:https://docs.gitlab.com/ee/ci/environments/