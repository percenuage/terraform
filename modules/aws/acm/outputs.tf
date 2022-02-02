output "aws_acm_certificate_domains" {
  value = keys(aws_acm_certificate.cert)
}
