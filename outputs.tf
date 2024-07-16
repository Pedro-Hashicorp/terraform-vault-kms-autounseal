output "name" {
    value = aws_instance.ec2_node[*].public_ip
} 

output "urls" {
  value = [
    for ip in aws_instance.ec2_node[*].public_ip : "http://${ip}:8200"
  ]
}