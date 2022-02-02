resource "aws_iam_instance_profile" "eks_cluster" {
  name = aws_iam_role.eks_cluster.name
  role = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "eks_cluster" {
  name = "${title(var.namespace)}${title(var.env)}EKSClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  force_detach_policies = true

  tags = {
    Name = local.name
    Role = "eks-cluster"
    Env = var.env
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_cluster.name
}

resource "aws_iam_instance_profile" "eks_node" {
  name = aws_iam_role.eks_node.name
  role = aws_iam_role.eks_node.name
}

resource "aws_iam_role" "eks_node" {
  name = "${title(var.namespace)}${title(var.env)}EKSNodeRole"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  force_detach_policies = true

  tags = {
    Name = local.name
    Role = "eks-node"
    Env = var.env
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_node.name
}
