output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig_certificate" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}

output "cluster" {
  value = {
    name = aws_eks_cluster.this.id
    endpoint = aws_eks_cluster.this.endpoint
  }
}
