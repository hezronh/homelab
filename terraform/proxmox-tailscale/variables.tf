variable "proxmox_password" {
  description = "Password for Proxmox root user"
  type        = string
  sensitive   = true
}

variable "vm_ssh_key" {
  description = "Public SSH key to inject via cloud-init."
  type        = string
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type = string
}

variable "pm_user" {
  description = "Proxmox Username"
  type = string
}

variable "pm_api_token_secret" {
  description = "API Token Secret"
  type = string
}

variable "pm_api_token_id" {
  description = "TokenID API"
  type = string
}
