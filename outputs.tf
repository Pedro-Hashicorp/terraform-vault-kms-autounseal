output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.privateSubnetA.id, aws_subnet.privateSubnetB.id, aws_subnet.privateSubnetC.id]
}

