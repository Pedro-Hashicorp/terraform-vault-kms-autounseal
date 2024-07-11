output "instance_ips" {
  value = aws_instance.ec2_node.private_ip
}
output "instance_ips2" {
  value = aws_instance.*.private_ip
}