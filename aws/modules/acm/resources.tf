/* AWS_ACM */

resource "aws_acm_certificate" "cert" {
  for_each = toset(var.domains)

  domain_name = "${local.subdomain}.${each.key}"
  validation_method = "DNS"

  tags = {
    Env = var.env
    Terraform = true
  }
}

resource "aws_route53_record" "cert" {
  for_each = toset(var.domains)

  name = aws_acm_certificate.cert[each.key].domain_validation_options.0.resource_record_name
  type = aws_acm_certificate.cert[each.key].domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  records = [aws_acm_certificate.cert[each.key].domain_validation_options.0.resource_record_value]
  ttl = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert" {
  for_each = toset(var.domains)

  certificate_arn = aws_acm_certificate.cert[each.key].arn
  validation_record_fqdns = [aws_route53_record.cert[each.key].fqdn]
}
