terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url           = var.pm_api_url
  pm_tls_insecure      = true
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret  = var.pm_api_token_secret
  pm_debug             = true
}
