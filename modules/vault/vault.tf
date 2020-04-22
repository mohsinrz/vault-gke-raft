resource "helm_release" "vault" {
  name          = "vault"
  chart         = "${path.root}/vault-helm"
  namespace     = kubernetes_namespace.vault.metadata.0.name

  values = [<<EOF
global:
  tlsDisable: false
server:
  extraEnvironmentVars:
    VAULT_ADDR: https://127.0.0.1:8200
    VAULT_SKIP_VERIFY: true
    VAULT_CACERT: /vault/userconfig/vault-tls/vault.ca
  extraVolumes:
    - type: secret
      name: vault-tls
  ha:
    enabled: true
    replicas: ${var.num_vault_pods}    

    raft:      
      # Enables Raft integrated storage
      enabled: true
      config: |
        ui = true

        listener "tcp" {
          tls_disable = 0
          address = "[::]:8200"
          cluster_address = "[::]:8201"
          tls_cert_file = "/vault/userconfig/vault-tls/vault.crt"
          tls_key_file  = "/vault/userconfig/vault-tls/vault.key"
          tls_client_ca_file = "/vault/userconfig/vault-tls/vault.ca"           
        }

        storage "raft" {
          path = "/vault/data"
        }
ui:
  enabled: true
  serviceType: "LoadBalancer"
  serviceNodePort: null
  externalPort: 8200
EOF
]
}

