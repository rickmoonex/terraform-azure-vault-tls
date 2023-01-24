resource "random_password" "password" {
  length  = 16
  special = false
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name = "ca.${var.shared_san}"
  }

  validity_period_hours = 8760
  allowed_uses          = ["cert_signing", "crl_signing"]
  is_ca_certificate     = true
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name = var.shared_san
  }

  dns_names = [
    var.shared_san,
    "*.${var.shared_san}",
    "localhost"
  ]
  ip_addresses = ["127.0.0.1"]
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}

resource "pkcs12_from_pem" "server" {
  password        = random_password.password.result
  cert_pem        = tls_locally_signed_cert.server.cert_pem
  private_key_pem = tls_private_key.server.private_key_pem
  ca_pem          = tls_self_signed_cert.ca.cert_pem
}
