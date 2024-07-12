output "name" {
    value = aws_instance.ec2_node[*].public_ip
} 

output "urls" {
  value = [
    for ip in aws_instance.ec2_node[*].public_ip : "https://${ip}:8200"
  ]
}