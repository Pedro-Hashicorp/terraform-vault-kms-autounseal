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
%{ for index in private_ips_array ~}
    ha_storage "raft" {
    path    = "opt/ha-raft_1/"
    node_id = "vault_1"
    }

    storage "file" {
    path = "opt/vault-storage-file/"
    }

    listener "tcp" {
        address = "127.0.0.1:8210"
        cluster_address = "127.0.0.1:8211"
        tls_disable = true
    }

    ui = true
    disable_mlock = true
    api_addr = "http://127.0.0.1:8210"
    cluster_addr = "http://127.0.0.1:8211"
%{ endfor ~}

EOT


mkdir -p /opt/vault/data
chown vault:vault /opt/vault/data
sudo systemctl enable vault
sudo systemctl start vault

sudo mkdir -p /opt/vault/data
sudo vault server -config=/etc/vault.d/vault.hcl
export VAULT_ADDR=http://0.0.0.0:8200
echo "export VAULT_ADDR=http://0.0.0.0:8200" | sudo tee -a /etc/environment
echo "export VAULT_API_ADDR=http://0.0.0.0:8200" | sudo tee -a /etc/environment

source /etc/environment

if [${count} != 1]; then
    sudo echo "hola mundo" >> dentro.txt
else
    sudo echo "hola mundo" >> fuera.txt
fi


#vault operator init -format=json > /home/ec2-user/key.json
#vault operator init -key-shares=3 -key-threshold=2 -format=json | tee /home/ec2-user/key.json
#sudo vault operator unseal $(jq -r '.unseal_keys_hex[0]' "key.json")
#sudo vault operator unseal $(jq -r '.unseal_keys_hex[1]' "key.json")
#sudo vault operator unseal $(jq -r '.unseal_keys_hex[2]' "key.json")
#sudo echo "hola mundo" >> hola.txt
#aws s3 cp key.json s3://pedroform-bucket/key-node-test-${count}.js
#sudo rm -r keys.json