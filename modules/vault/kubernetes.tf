resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
  depends_on = [var.cluster_endpoint]
}

resource "kubernetes_secret" "vault-tls" {
  metadata {
    name      = "vault-tls"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "vault.ca"      = var.vault_tls_ca
    "vault.crt"     = var.vault_tls_cert
    "vault.key"     = var.vault_tls_key
  }

  type = "Opaque"
}