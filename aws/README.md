# Terraform • percenuage

This script could create these resources for each env [prod|staging|test|dev]:

- **AWS VPC** for VPC with default resources (`./modules/vpc`)
- **AWS ACM** for SSL certificates (`./modules/acm`)
- **AWS SES** for email service (`./modules/ses`)

These modules use shared **userdata** (`./modules/userdata`) which is **cloud-init** resources to setup and configure ec2.
In the future, they could be replace by **Ansible** script.

The organisation of terraform structure is driven by environment in a dedicated folder:

```shell script
- .
- modules/
- env/
    - prod/
      - versions.tf
      - providers.tf
      - modules.tf
      - outputs.tf
      - variables.tf
    - staging/
    - test/
    - dev/
```

The `terraform.tfstate` is stored in S3 bucket `percenuage-terraform/state/$ENV/infra.tfstate`.

## Getting Started

You need to have in your path:

- [terraform](https://www.terraform.io/downloads.html) (>= 0.14.9)

```sh
$ terraform init -reconfigure env/$ENV
$ terraform apply env/$ENV
```

## Providers

- For **all modules**, you need to have `aws` cli installed and configured with admin access.

- For **EKS module**, you need to have in your path:
    - [**kubectl**](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) (>= v1.15)
    - [**helm**](https://helm.sh/docs/intro/install/) (>= v3)

## Variables

> Check `variables.tf` with default value only. The others will be prompt during apply.
> You can override it by changing default values, create `terraform.tfvars` or in cli `$ terraform apply -var="aws_region=eu-central-1"`


| Variable       | Default                  |
|----------------|--------------------------|
| aws_region     | eu-west-3                |

## TODO

- [x] Modules
- [x] Env
- [x] [Backend S3](https://www.terraform.io/docs/backends/types/s3.html)
- [x] Rancher module
- [ ] Enable Cloudtrail for each env
