output "name" {
    value = "http://${aws_instance.ec2_node[*].public_ip}:8200"
} 