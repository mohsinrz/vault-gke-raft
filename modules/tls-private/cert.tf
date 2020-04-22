resource "tls_private_key" "cert" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "cert" {
  key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  dns_names = [var.hostname]

  ip_addresses = [
    "127.0.0.1",
  ]

  subject {
    common_name  = var.hostname
    organization = "Vault Private Certificate"
  }
}

resource "tls_locally_signed_cert" "cert" {
  cert_request_pem   = tls_cert_request.cert.cert_request_pem
  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.certificate_duration
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}
