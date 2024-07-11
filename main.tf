provider "aws" {
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
  private_ip             = var.private_ips[0]

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-nodeA"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update and install necessary packages
              sudo yum -y update
              sudo yum install -y yum-utils

              # Add HashiCorp Linux repository
              sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

              # Install Vault
              sudo yum -y install vault

              sudo systemctl start vault
              sudo systemctl enable vault
              EOF
}

resource "aws_instance" "ec2_subnetB" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.privateSubnetB.id
  key_name               = "portiz"
  private_ip             = var.private_ips[1]

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
  private_ip             = var.private_ips[2]

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-nodeC"
  }
}