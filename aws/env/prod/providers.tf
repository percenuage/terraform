provider "aws" {
  profile = "default"
  region = var.aws_region
  ignore_tags {
    key_prefixes = ["kubernetes.io/cluster/"]
  }
}

provider "aws" {
  alias = "ses"
  region = "eu-west-1"
}

provider "kubernetes" {}

terraform {
  backend "s3" { // Unable to use variable here https://github.com/hashicorp/terraform/issues/13022
    bucket = "percenuage-infra"
    key = "terraform/state/prod/infra.tfstate"
    region = "eu-west-3"
  }
}
