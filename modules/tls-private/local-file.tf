locals {
  full_cert = "${tls_locally_signed_cert.cert.cert_pem}\n${tls_self_signed_cert.ca.cert_pem}"
}

resource "local_file" "tls-certificate" {
  filename = "./tls/certificate.cert"
  content  = local.full_cert
}

resource "local_file" "tls-key" {
  filename = "./tls/private.key"
  content  = tls_private_key.cert.private_key_pem
}

resource "local_file" "ca-tls-certificate" {
  filename = "./tls/ca-certificate.cert"
  content  = tls_self_signed_cert.ca.cert_pem
}

resource "local_file" "ca-tls-key" {
  filename = "./tls/ca-private.key"
  content  = tls_private_key.ca.private_key_pem
}
