output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_tags" {
  value = aws_vpc.main.tags
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "logs_bucket" {
  value = module.s3_bucket_logs.this_s3_bucket_id
}

output "vpc" {
  value = {
    tags = aws_vpc.main.tags
    cidr = aws_vpc.main.cidr_block
    logs_bucket = module.s3_bucket_logs.this_s3_bucket_id
  }
}
