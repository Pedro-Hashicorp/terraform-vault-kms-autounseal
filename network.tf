resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ec2_vpc"
  }
}

resource "aws_subnet" "privateSubnets" {
  count = 3
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "subnet-${var.availability_zones[count.index]}"
  }
}

#Attach Internet Gateway to VPC
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "dev-igw"
  }
}


#Add default Route of VPC to point Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

#Associate the route table created to every subnet
resource "aws_route_table_association" "subnet_assoc" {
  for_each = { for idx, subnet in aws_subnet.privateSubnets : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_public_rt.id
}
