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


"unseal_keys_hex": [
    "d924ceaf944716aed6b01186163d3859717f9b91c011dfc46049999696198aaf1b",
    "76433bd85e67e3e5ac3e92f137d80f5a92d700cece8c546d59febd0b53298366df",
    "9553eb7f1512333deaf4b9561ebf42be26bb4acacb15a95d117ca39241eb09c991"


    "uYzJvzJUNVY+4G1RZRkURrj7hJhOEI4cIyKWfhVaR+SQ",
    "knRQQqkef8/fz1FcpEOhuOFDFd4wZ6aRelgOktLsiYN7",
    "CyQJ3NuO75b4AG4+BZCElYEE4LQzUIzdGg3P1w56Yffb"


    vault operator unseal uYzJvzJUNVY+4G1RZRkURrj7hJhOEI4cIyKWfhVaR+SQ
        vault operator unseal knRQQqkef8/fz1FcpEOhuOFDFd4wZ6aRelgOktLsiYN7


        vault operator rekey \
    -init \
    -key-shares=3 \
    -key-threshold=2
