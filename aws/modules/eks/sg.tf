module "cluster_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-cluster-sg"
  description = title("${var.namespace} ${var.env} K8S Cluster SG")
  vpc_id = data.aws_vpc.selected.id
  use_name_prefix = false

  egress_rules = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Allow pods to communicate with the EKS cluster API."
      source_security_group_id = module.node_sg.this_security_group_id
    }
  ]

  tags = {
    Env = var.env
    Role = "eks-cluster"
    Terraform = "true"
  }
}

module "node_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-node-sg"
  description = title("${var.namespace} ${var.env} K8S Node SG")
  vpc_id = data.aws_vpc.selected.id
  use_name_prefix = false

  egress_rules = ["all-all"]
  ingress_with_self = [
    {
      from_port = 0
      to_port = 0
      protocol = -1
      description = "Allow node to communicate with each other."
      self = true
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
      source_security_group_id = module.cluster_sg.this_security_group_id
    },
    {
      from_port = 1025
      to_port = 65535
      protocol = "tcp"
      description = "Allow workers pods to receive communication from the cluster control plane."
      source_security_group_id = module.cluster_sg.this_security_group_id
    }
  ]

  tags = {
    Env = var.env
    Role = "eks-node"
    Terraform = "true"
  }
}
