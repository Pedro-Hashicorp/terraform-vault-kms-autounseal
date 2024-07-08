#!/bin/bash
              
              # Update and install dependencies
              yum update -y
              yum install -y curl

              # Install Vault
              VAULT_VERSION=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | grep 'tag_name' | cut -d\" -f4)
              echo "Latest Vault version: ${VAULT_VERSION}"
              curl -fsSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip
              unzip vault.zip
              sudo mv vault /usr/local/bin/
              sudo chmod +x /usr/local/bin/vault

              # Create Vault directory and configuration file
              sudo mkdir -p /etc/vault.d
              cat <<EOT | sudo tee /etc/vault.d/vault.hcl
              storage "file" {
                path = "/mnt/vault/data"
              }

              listener "tcp" {
                address     = "0.0.0.0:8200"
                tls_disable = 1
              }

              disable_mlock = true
              ui            = true
              EOT

              # Create Vault data directory
              sudo mkdir -p /mnt/vault/data

              # Enable and start Vault service
              sudo tee /etc/systemd/system/vault.service <<EOT
              [Unit]
              Description=Vault service
              Documentation=https://www.vaultproject.io/docs/
              After=network-online.target

              [Service]
              User=vault
              Group=vault
              ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
              Restart=on-failure

              [Install]
              WantedBy=multi-user.target
              EOT

              sudo systemctl enable vault
              sudo systemctl start vault