output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault_access_policy.vault.key_vault_id
}

output "key_vault_ssl_cert_secret_id" {
  description = "Secret ID of Key Vault Certificate for Vault TLS"
  value       = azurerm_key_vault_certificate.vault.secret_id
}

output "key_vault_vm_tls_secret_id" {
  description = "Key Vault Secret id where VM TLS cert info is stored"
  value       = azurerm_key_vault_secret.vault_tls.id
}

output "key_vault_vm_ssh_secret_id" {
  description = "Key Vault Secret id where VM SSH key info is stored"
  value       = azurerm_key_vault_secret.vault_ssh.id
}

output "pfx_password" {
  description = "The password used for the PFX certificate"
  value       = random_password.password.result
}

output "root_ca_pem" {
  description = "The root CA in PEM format"
  value       = tls_self_signed_cert.ca.cert_pem
}

output "shared_san" {
  description = "The shared san of the server certificate"
  value       = tls_cert_request.server.dns_names[0]
}

output "ssh_public_key" {
  description = "The generated ssh public key"
  value       = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key" {
  description = "The generated ssh private key"
  value       = tls_private_key.ssh.private_key_openssh
}
