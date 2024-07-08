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

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y yum-utils
              sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              sudo yum -y install vault

              sudo tee /etc/vault.d/vault.hcl > /dev/null <<EOT
              storage "file" {
                path = "/opt/vault/data"
              }

              listener "tcp" {
                address     = "0.0.0.0:8200"
                tls_disable = 1
              }

              api_addr = "http://0.0.0.0:8200"
              cluster_addr = "http://0.0.0.0:8201"
              ui = true
              EOT

              sudo systemctl enable vault
              sudo systemctl start vault
              EOF
}