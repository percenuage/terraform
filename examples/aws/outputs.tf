output "vpc" {
  value = module.vpc.vpc
}

output "acm_domains" {
  value = module.acm.aws_acm_certificate_domains
}

output "ses_domains" {
  value = module.ses.aws_ses_domain_identity
}

output "s3_percenuage_design" {
  value = module.s3_percenuage_design.this_s3_bucket_bucket_domain_name
}

