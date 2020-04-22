resource "tls_private_key" "ca" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm         = tls_private_key.ca.algorithm
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = var.certificate_duration

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]

  subject {
    organization = "Arctiq"
    common_name  = "Arctiq Private Certificate Authority"
    country      = "Canada"
  }
}
