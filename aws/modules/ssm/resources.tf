resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

/* AWS_SSM */

resource "aws_ssm_parameter" "ssh_private_key" {
  name = "${local.path}/private_key"
  description = "SSH private key"
  type = "SecureString"
  value = tls_private_key.ssh.private_key_pem

  tags = {
    Name = "private_key"
    Role = "ssh"
    Domain = "srv"
    Env = var.env
    Terraform = "true"
  }
}

resource "aws_ssm_parameter" "ssh_public_key" {
  name = "/${var.env}/srv/ssh/public_key"
  description = "SSH public key"
  type = "String"
  value = "${chomp(tls_private_key.ssh.public_key_openssh)} ${var.user}@${var.env}"

  tags = {
    Name = "public_key"
    Role = "ssh"
    Domain = "srv"
    Env = var.env
    Terraform = "true"
  }
}
