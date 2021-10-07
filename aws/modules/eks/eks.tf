resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"

  tags = {
    Env = var.env
    Terraform = true
  }
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "/aws/eks/${local.name}/cluster"
  retention_in_days = 30

  tags = {
    Env = var.env
    Terraform = true
  }
}

resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role.eks_cluster,
    aws_iam_role.eks_node,
    aws_cloudwatch_log_group.cluster
  ]

  name = "${local.name}-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator"] # controllerManager|scheduler

  vpc_config {
    security_group_ids = [module.cluster_sg.this_security_group_id]
    subnet_ids = data.aws_subnet_ids.all.ids
  }

  encryption_config {
    provider  {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }

  tags = {
    Name = local.name
    Role = "eks-cluster"
    Env = var.env
    Terraform = "true"
  }
}

resource "aws_eks_node_group" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker,
    aws_iam_role_policy_attachment.eks_node_registry,
    aws_iam_role_policy_attachment.eks_node_cni
  ]

  node_group_name = "${local.name}-node"
  cluster_name = aws_eks_cluster.this.name
  node_role_arn = aws_iam_role.eks_node.arn
  subnet_ids = data.aws_subnet_ids.all.ids

  instance_types = [var.instance_type]
  disk_size = 100

  remote_access {
    ec2_ssh_key = var.aws_ssh_key_name
    source_security_group_ids = [module.node_sg.this_security_group_id]
  }

  scaling_config {
    desired_size = 1
    min_size = 1
    max_size = 10
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = {
    Name = local.name
    Role = "eks-node"
    Env = var.env
    Terraform = "true"
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.this]
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.this.id}"
  }
}


//resource "kubernetes_config_map" "aws_auth" {
//  depends_on = [null_resource.update_kubeconfig]
//
//  metadata {
//    name = "aws-auth"
//    namespace = "kube-system"
//  }
//
//  data = {
//    mapRoles = yamlencode(
//      [
//        {
//          rolearn: aws_iam_role.eks_node.arn,
//          username: "system:node:{{EC2PrivateDNSName}}",
//          groups: [
//            "system:bootstrappers",
//            "system:nodes"
//          ]
//        }
//      ]
//    )
//  }
//}
