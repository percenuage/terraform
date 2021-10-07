output "aws_ssm_ssh_key_path" {
  value = "${aws_ssm_parameter.ssh_public_key.name}|${aws_ssm_parameter.ssh_private_key.name}"
}
