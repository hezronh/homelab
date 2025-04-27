terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.68.70:8006/api2/json"
  insecure = true
  username = "root@pam"
  password = var.proxmox_password
}

resource "proxmox_virtual_environment_vm" "tailscale_vm" {
  name      = "tailscale-node"
  node_name = "pve"         # <-- jouw servernaam in Proxmox

  clone {
    vm_id = 9000                           # <-- jouw ubuntu-base template ID
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8                       # Disk size in GB
    interface    = "scsi0"                 # ✅ Verplicht in bpg provider
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  initialization {
    user_account {
      username = "ubuntu"
      password = var.vm_password
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  agent {
    enabled = true
  }
 
  
}
