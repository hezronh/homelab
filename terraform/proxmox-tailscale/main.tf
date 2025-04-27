terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url       = "https://192.168.68.70:8006/api2/json"
  pm_tls_insecure = true
  pm_user         = "root@pam"
  pm_password     = var.proxmox_password
}

resource "proxmox_vm_qemu" "tailscale_vm" {
  name         = "tailscale-node"
  target_node  = "pve"        # <-- de naam van je Proxmox node
  clone        = "ubuntu-base-vm" # <-- de naam van je template, NIET de ID
  full_clone   = true         # <-- aanbevolen voor cloud-init VM's
  agent        = 1            # QEMU Guest Agent inschakelen
  os_type      = "cloud-init"
  
  cores        = 1
  sockets      = 1
  memory       = 512

  disk {
    slot           = "scsi0"
    size           = "8G"
    type           = "disk"
    storage        = "local-lvm"
    discard        = true
    backup         = false
  }

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.72/24,gw=192.168.68.1"

  sshkeys = <<EOF
  ${var.vm_ssh_key}
  EOF

  # Optional: maak VM automatisch bootable op virtio0
  boot = "order=scsi0"
}
