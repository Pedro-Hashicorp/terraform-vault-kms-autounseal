cluster_addr  = "http://10.0.1.100:8201"
api_addr      = "http://10.0.1.100:8200"
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