/* AWS_VPC*/

resource "aws_vpc" "main" {
  cidr_block = "10.${var.index}.0.0/16"

  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-vpc"
    Env = var.env
    Terraform = "true"
  }
}

/* AWS_SUBNET */

resource "aws_subnet" "az" {
  count = local.subnet_count

  vpc_id = aws_vpc.main.id
  cidr_block = "10.${var.index}.${16 * count.index}.0/20"
  availability_zone = "${var.aws_region}${local.zones[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-az${count.index + 1}-public-subnet"
    Env = var.env
    AZ = count.index + 1
    Terraform = "true"
  }
}

/* AWS_GW */

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-vpc"
    Env = var.env
    Terraform = "true"
  }
}

/* AWS_RT */

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.name}-rt"
    Env = var.env
    Terraform = "true"
  }
}

resource "aws_route_table_association" "az" {
  count = local.subnet_count

  subnet_id = aws_subnet.az[count.index].id
  route_table_id = aws_route_table.rt.id
}

/* AWS_SG */

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = -1
    self = true
    from_port = 0
    to_port = 0
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-default-sg"
    Env = var.env
    Role = "default"
    Terraform = "true"
  }
}

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-web-sg"
  description = title("${var.namespace} ${var.env} Web SG")
  vpc_id = aws_vpc.main.id
  use_name_prefix = false

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules = ["all-all"]

  tags = {
    Env = var.env
    Role = "web"
    Terraform = "true"
  }
}

module "admin_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-admin-sg"
  description = title("${var.namespace} ${var.env} Admin SG")
  vpc_id = aws_vpc.main.id
  use_name_prefix = false

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]

  tags = {
    Env = var.env
    Role = "admin"
    Terraform = "true"
  }
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-db-sg"
  description = title("${var.namespace} ${var.env} DB SG")
  vpc_id = aws_vpc.main.id
  use_name_prefix = false

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules = ["mysql-tcp"]
  egress_rules = ["all-all"]

  tags = {
    Env = var.env
    Role = "db"
    Terraform = "true"
  }
}

/* AWS_EBS */

resource "aws_ebs_encryption_by_default" "all" {
  enabled = true
}

/* AWS_S3 */

module "s3_bucket_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "1.6.0"

  bucket = "${local.name}-logs"
  region = var.aws_region
  create_bucket = var.enable_s3_logs
  force_destroy = true

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  tags = {
    Name = "${local.name}-logs"
    Role = "logs"
    Env = var.env
    Workspace = terraform.workspace
    Terraform = "true"
  }
}

