module "vpc" {
  source = "../../modules/vpc"

  index = 0
  env = var.env
  namespace = var.namespace
  enable_s3_logs = true
}

module "acm" {
  source = "../../modules/acm"

  domains = [
    "percenuage.fr",
  ]
  env = var.env
}

module "ses" {
  source = "../../modules/ses"
  providers = {
    aws = aws.ses
  }

  domains = [
    "percenuage.fr",
  ]
  env = var.env
}

module "s3_percenuage" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "1.6.0"

  bucket = "${var.namespace}-design"
  acl = "public-read"

  versioning = {
    enabled = true
  }

  tags = {
    Name = "${var.namespace}-design"
    Env = var.env
    Role = "s3"
    Terraform = "true"
  }
}
