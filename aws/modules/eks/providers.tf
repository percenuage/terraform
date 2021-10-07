provider "kubernetes" {
  host = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = aws_eks_cluster.this.certificate_authority.0.data
  token = data.aws_eks_cluster_auth.cluster.token
  load_config_file = false
}
