data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(var.subnet_cidrs)

  filter {
    name   = "cidrBlock"
    values = [each.key]
  }

  depends_on = [aws_subnet.privateSubnets]
}
