data "aws_vpc" "selected" {
  tags = {
    Env: var.env
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_groups" "all" {
  tags = {
    Env: var.env
  }
  filter {
    name = "tag:Role"
    values = ["admin", "default"]
  }
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.id
}
