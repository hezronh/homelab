variable "proxmox_password" {
  description = "Password for Proxmox root user"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "Password for the Ubuntu VM user"
  type        = string
  sensitive   = true
}

variable "vm_ssh_key" {
  description = "Public SSH key to inject via cloud-init."
  type        = string
}

