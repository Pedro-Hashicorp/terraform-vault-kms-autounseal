provider "aws" {
  region = "eu-west-1"
}


resource "aws_kms_key" "vault_unseal" {
  description             = "KMS Key for Vault Auto-Unseal"
  deletion_window_in_days = 10
}


#Create a Route table for the VP
resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}


resource "aws_instance" "ec2_node" {
  count = 3
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.aws_subnet.subnets[var.subnet_cidrs[count.index]].id
  key_name               = "portiz"
  private_ip             = var.private_ips[count.index]
  iam_instance_profile = aws_iam_instance_profile.iam-for-ec2-create-s33.name


  root_block_device {
    volume_size = 20
  }

  
  tags = {
    Name = "dev-node-${count.index+1}"
  }

 user_data = base64encode(templatefile("${path.module}/vault-script.sh.tftpl",{
  count = count.index +1,
  kms_key = aws_kms_key.vault_unseal.id,
  cert_gen_script = filebase64("${path.module}/utils/cert-gen.sh"),
  ca_cert         = filebase64("${path.module}/utils/vault-ca/vault-ca.pem"),
  ca_key          = filebase64("${path.module}/utils/vault-ca/vault-ca.key"),
  vault_service   = filebase64("${path.module}/vault.service")
  }))
}
