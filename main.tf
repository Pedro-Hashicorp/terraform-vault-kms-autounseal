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

resource "aws_s3_bucket" "my_bucket" {
  bucket = "pedroform-bucket"  # Replace with your unique bucket name
  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl = "private"
  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_instance" "ec2_node" {
  count = 1
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.aws_subnet.subnets[var.subnet_cidrs[count.index]].id
  key_name               = "portiz"
  private_ip             = var.private_ips[count.index]
  iam_instance_profile = aws_iam_instance_profile.s3_access_instance_profile.name


  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-node-${count.index+1}"
  }

 user_data = templatefile("${path.module}/vault-conf.tpl",{
  private_ip = var.private_ips[count.index],
  count = count.index +1
 })
}