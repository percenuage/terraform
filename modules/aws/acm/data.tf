data "aws_route53_zone" "zone" {
  for_each = toset(var.domains)

  name = each.key
}
