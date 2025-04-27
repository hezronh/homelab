variable "vm_ssh_key" {
  description = "Public SSH key to inject into the VM via cloud-init."
  type        = string
  validation {
    condition     = can(regex("^ssh-(rsa|ed25519)\\s", var.vm_ssh_key))
    error_message = "The SSH key must be a valid public key starting with 'ssh-rsa' or 'ssh-ed25519'."
  }
}

variable "pm_api_url" {
  description = "Proxmox API base URL, e.g., https://proxmox.example.com:8006/api2/json"
  type        = string
  validation {
    condition     = can(regex("^https://", var.pm_api_url))
    error_message = "The Proxmox API URL must start with https://"
  }
}

variable "pm_api_token_secret" {
  description = "The secret part of the Proxmox API token."
  type        = string
  sensitive   = true
}

variable "pm_api_token_id" {
  description = "The full API Token ID in the format 'user@realm!tokenname'."
  type        = string
  validation {
    condition     = can(regex(".+@.+!.+", var.pm_api_token_id))
    error_message = "The Token ID must follow the format 'user@realm!tokenname'."
  }
}
