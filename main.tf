data "azurerm_client_config" "current" {}

resource "random_id" "key_vault_suffix" {
  byte_length = floor((24 - (length(var.resource_name_prefix) + 7)) / 2)
}

resource "azurerm_key_vault" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault-${random_id.key_vault_suffix.hex}"
  resource_group_name = var.resource_group.name
  sku_name            = "standard"
  tags                = var.common_tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_access_policy" "vault" {
  key_vault_id = azurerm_key_vault.vault.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Purge",
    "Set",
    "Recover"
  ]
}

resource "azurerm_key_vault_certificate" "vault" {
  key_vault_id = azurerm_key_vault_access_policy.vault.key_vault_id
  name         = "${var.resource_name_prefix}-vault-cert"
  tags         = var.common_tags

  certificate {
    contents = pkcs12_from_pem.server.result
    password = random_password.password.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

resource "azurerm_key_vault_secret" "vault_tls" {
  key_vault_id = azurerm_key_vault_access_policy.vault.key_vault_id
  name         = "${var.resource_name_prefix}-vault-vm-tls"
  tags         = var.common_tags
  value        = pkcs12_from_pem.server.result
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "vault_ssh" {
  key_vault_id = azurerm_key_vault_access_policy.vault.key_vault_id
  name         = "${var.resource_name_prefix}-vault-vm-ssh"
  tags         = var.common_tags
  value        = tls_private_key.ssh.private_key_openssh
}
