terraform {
  required_version = ">= 1.2.1"

  required_providers {
    azurerm = ">=3.0"
    random  = ">=1.0"
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.0.7"
    }
  }
}
