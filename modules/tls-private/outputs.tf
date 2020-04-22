output "ca_cert" {
  description = "CA certificate in PEM format."
  value       = tls_self_signed_cert.ca.cert_pem
}

output "cert" {
  description = "Full chain certificate in PEM format."
  value       = local.full_cert
}

output "key" {
  description = "Certification key in PEM format."
  value       = tls_private_key.cert.private_key_pem
}

output "cert_b64" {
  description = "The PEM certification in base64."
  value       = base64encode(local.full_cert)
}
