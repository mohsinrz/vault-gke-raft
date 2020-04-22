variable "hostname" {
  description = "The full hostname that will be used. `vault.example.com`"
}

variable "certificate_duration" {
  description = "Length in hours for the certificate and authority to be valid. Defaults to 6 months."
  default     = 24 * 30 * 6
}
