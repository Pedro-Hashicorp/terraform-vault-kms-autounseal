resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "aws_key_pair" "existing" {
  key_name = "portiz" # Replace with your key pair name
}

# Local variable to determine if the key pair exists
locals {
  key_pair_exists = length(data.aws_key_pair.existing.id) > 0
}

resource "aws_key_pair" "kp" {
  count      = local.key_pair_exists ? 0 : 1
  key_name   = "portiz" # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./portiz.pem"
  }
}