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


resource "aws_instance" "ec2_node" {
  count = 3
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.aws_subnet.subnets[var.subnet_cidrs[count.index]].id
  key_name               = "portiz"
  private_ip             = var.private_ips[count.index]

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-node-${count.index+1}"
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
              sudo yum -y install jq


              # Create Vault configuration
              sudo mkdir -p /etc/vault.d
              cat <<EOL | sudo tee /etc/vault.d/vault.hcl
             storage "raft" {
                path    = "/opt/vault/data"
                node_id = "node${count.index + 1}"
              }
              listener "tcp" {
                address     = "0.0.0.0:8200"
                tls_disable = 1
              }
              api_addr = "http://${var.private_ips[count.index]}:8200"
              cluster_addr = "http://${var.private_ips[count.index]}:8201"
              EOT

              # Start Vault
              sudo systemctl enable vault
              sudo systemctl start vault

              # Join the cluster
              sleep 30  # Wait for leader to be ready
              vault operator join http://${var.private_ips[0]}:8200

              api_addr = "http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):8200"
              cluster_addr = "http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):8201"
              ui = true
              EOL

              # Start Vault
              sudo mkdir -p /opt/vault/data
              sudo vault server -config=/etc/vault.d/vault.hcl 


              sudo systemctl start vault
              sudo systemctl enable vault
              vault operator init > /home/ec2-user/key.json
              cd /home/ec2-user
              unseal_key1=$(jq -r '.unseal_keys_hex[0]' "key.json")
              unseal_key2=$(jq -r '.unseal_keys_hex[1]' "key.json")
              unseal_key3=$(jq -r '.unseal_keys_hex[2]' "key.json")



              EOF
}