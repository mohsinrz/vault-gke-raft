output "vault_url" {
  value = "https://${data.kubernetes_service.vault_svc.load_balancer_ingress.0.ip}:8200"
}
