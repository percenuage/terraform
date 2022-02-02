output "aws_ses_domain_identity" {
  value = keys(aws_ses_domain_identity.domains)
}
