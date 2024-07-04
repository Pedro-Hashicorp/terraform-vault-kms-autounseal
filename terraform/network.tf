resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name="ec2_vpc"
    }
}

resource "aws_subnet" "privateSubnetA" {
  vpc_id        = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"

  tags ={
    Name="subnet-a"
  }
}

resource "aws_subnet" "privateSubnetB" {
  vpc_id        = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags ={
    Name="subnet-b"
  }
}
resource "aws_subnet" "privateSubnetC" {
  vpc_id        = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1c"

  tags ={
    Name="subnet-c"
  }
}

#Attach Internet Gateway to VPC
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw"
  }
}