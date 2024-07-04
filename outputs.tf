output "instance_ips" {
  value = aws_instance.ec2_subnetA.private_ip
}
output "instance_ips2" {
  value = aws_instance.ec2_subnetB.private_ip
}
output "instance_ips3" {
  value = aws_instance.ec2_subnetC.private_ip
}