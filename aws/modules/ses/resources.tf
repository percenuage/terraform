/* AWS_SES */

resource "aws_ses_domain_identity" "domains" {
  for_each = toset(var.domains)

  domain = each.key
}

resource "aws_ses_domain_dkim" "domains" {
  for_each = toset(var.domains)

  domain = aws_ses_domain_identity.domains[each.key].domain
}

resource "aws_route53_record" "domains_amazonses_dkim_record_0" {
  for_each = toset(var.domains)

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name = "${aws_ses_domain_dkim.domains[each.key].dkim_tokens[0]}._domainkey.${each.key}"
  type = "CNAME"
  ttl = "600"
  records = ["${aws_ses_domain_dkim.domains[each.key].dkim_tokens[0]}.dkim.amazonses.com"]
  allow_overwrite = true
}

resource "aws_route53_record" "domains_amazonses_dkim_record_1" {
  for_each = toset(var.domains)

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name = "${aws_ses_domain_dkim.domains[each.key].dkim_tokens[1]}._domainkey.${each.key}"
  type = "CNAME"
  ttl = "600"
  records = ["${aws_ses_domain_dkim.domains[each.key].dkim_tokens[1]}.dkim.amazonses.com"]
  allow_overwrite = true
}

resource "aws_route53_record" "domains_amazonses_dkim_record_2" {
  for_each = toset(var.domains)

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name = "${aws_ses_domain_dkim.domains[each.key].dkim_tokens[2]}._domainkey.${each.key}"
  type = "CNAME"
  ttl = "600"
  records = ["${aws_ses_domain_dkim.domains[each.key].dkim_tokens[2]}.dkim.amazonses.com"]
  allow_overwrite = true
}

resource "aws_ses_domain_identity_verification" "domains_verification" {
  for_each = toset(var.domains)

  domain = aws_ses_domain_identity.domains[each.key].id

  depends_on = [aws_route53_record.domains_amazonses_verification_record]
}

resource "aws_route53_record" "domains_amazonses_verification_record" {
  for_each = toset(var.domains)

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name = "_amazonses.${aws_ses_domain_identity.domains[each.key].id}"
  type = "TXT"
  ttl = "600"
  records = [aws_ses_domain_identity.domains[each.key].verification_token]
  allow_overwrite = true
}

