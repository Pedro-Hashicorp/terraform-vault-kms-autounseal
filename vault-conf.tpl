#!/bin/bash
# Update and install necessary packages
sudo yum -y update
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Vault
sudo yum -y install vault
sudo yum -y install jq

# Create Vault configuration
sudo mkdir -p /etc/vault.d
cat << EOT | sudo tee /etc/vault.d/vault.hcl
cluster_addr  = "http://${private_ip}:8201"
api_addr      = "http://${private_ip}:8200"
disable_mlock = true

listener "tcp" {
    address     = "0.0.0.0:8200"
    tls_disable = 1
}

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "node1"

retry_join {
    leader_api_addr         = "http://10.0.2.100:8200"
}

retry_join {
    leader_api_addr         = "http://10.0.3.100:8200"
  }
}
ui="true"
EOT


mkdir -p /opt/vault/data
chown vault:vault /opt/vault/data

# Start Vault
sudo systemctl enable vault
sudo systemctl start vault

sudo mkdir -p /opt/vault/data
sudo vault server -config=/etc/vault.d/vault.hcl
export VAULT_ADDR=http://0.0.0.0:8200
echo "export VAULT_ADDR=http://0.0.0.0:8200" | sudo tee -a /etc/environment
echo "export VAULT_API_ADDR=http://0.0.0.0:8200" | sudo tee -a /etc/environment

source /etc/environment

if [${count} != 1]; then
    echo "hola mundo" >> dentro.txt

else
    echo "hola mundo" >> fuera.txt

fi

vault operator init -format=json > /home/ec2-user/key.json
sudo vault operator unseal $(jq -r '.unseal_keys_hex[0]' "key.json")
sudo vault operator unseal $(jq -r '.unseal_keys_hex[1]' "key.json")
sudo vault operator unseal $(jq -r '.unseal_keys_hex[2]' "key.json")
sudo echo "hola mundo" >> hola.txt
aws s3 cp key.json s3://pedroform-bucket/key-node-test-${count}.js
sudo rm -r keys.json
