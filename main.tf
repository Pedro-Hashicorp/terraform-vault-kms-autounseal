provider "aws"{
    region = "eu-west-1"
}



#Create a Route table for the VPC
resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

#Add default Route of VPC to point Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}


resource "aws_route_table_association" "subnetA_assoc" {
  subnet_id      = aws_subnet.privateSubnetA.id
  route_table_id = aws_route_table.my_public_rt.id
}
resource "aws_route_table_association" "subnetB_assoc" {
  subnet_id      = aws_subnet.privateSubnetB.id
  route_table_id = aws_route_table.my_public_rt.id
}
resource "aws_route_table_association" "subnetC_assoc" {
  subnet_id      = aws_subnet.privateSubnetC.id
  route_table_id = aws_route_table.my_public_rt.id
}



resource "aws_instance" "ec2_subnetA" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.privateSubnetA.id
  key_name               = "portiz"

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-nodeA"
  }
}

resource "aws_instance" "ec2_subnetB" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.privateSubnetB.id
  key_name               = "portiz"

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-nodeB"
  }
}

resource "aws_instance" "ec2_subnetC" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.privateSubnetC.id
  key_name               = "portiz"

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-nodeC"
  }

provisioner "file" {
    source      = "vault-config.hcl"
    destination = "/tmp/vault-config.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip",
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository 'deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main'",
      "sudo apt-get update",
      "sudo apt-get install -y vault",
      "sudo mv /tmp/vault-config.hcl /etc/vault.d/vault.hcl",
      "sudo systemctl enable vault",
      "sudo systemctl start vault"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

}