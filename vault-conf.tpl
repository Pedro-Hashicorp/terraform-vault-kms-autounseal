#!/bin/bash
# Update and install necessary packages
sudo yum -y update
sudo yum install -y yum-utils
export VAULT_ADDR="http://0.0.0.0:8200"
export TEST="TEST213123"
# Add HashiCorp Linux repository
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Vault
sudo yum -y install vault
sudo yum -y install jq

# Create Vault configuration
sudo mkdir -p /etc/vault.d
cat << EOT | sudo tee /etc/vault.d/vault.hcl
storage "raft" {
    path    = "/opt/vault/data"
    node_id = "node${count}"
}
listener "tcp" {
    address     = "0.0.0.0:8200"
    tls_disable = 1
}

api_addr = "http://${private_ip}:8200"
cluster_addr = "http://${private_ip}:8201"
EOT

export VAULT_ADDR="http://0.0.0.0:8200"
# Start Vault
sudo systemctl enable vault
sudo systemctl start vault

sudo mkdir -p /opt/vault/data
sudo vault server -config=/etc/vault.d/vault.hcl &


vault operator init -format=json > /home/ec2-user/key.json
cd /home/ec2-user
echo "asdasdasd" >> hola.txt
vault operator unseal $(jq -r '.unseal_keys_hex[0]' "key.json")
vault operator unseal $(jq -r '.unseal_keys_hex[1]' "key.json")
vault operator unseal $(jq -r '.unseal_keys_hex[2]' "key.json")
