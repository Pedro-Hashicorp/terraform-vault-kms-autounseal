output "instance_ips" {
  value = aws_instance.*.public_ip
}

resource "null_resource" "write_outputs" {
  provisioner "local-exec" {
    command = <<EOT
      terraform output -json > terraform_outputs.json
    EOT
  }
}