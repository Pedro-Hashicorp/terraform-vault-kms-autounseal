output "name" {
    value = aws_instance.ec2_node[*].public_ip
} 

