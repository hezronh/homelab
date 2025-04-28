resource "proxmox_vm_qemu" "k3s-master" {
  name            = "k3s-master"
  desc            = "Kubernetes Master Node"
  target_node     = "pve"
  agent           = 1
  tags            = "K3s"
  vmid            = 4000
  clone           = "ubuntu-20.04-cloud-init-template"
  full_clone      = true
  onboot          = true
  automatic_reboot= true
  qemu_os         = "l26"
  cores           = 2
  sockets         = 1
  cpu_type        = "host"
  memory          = 4096
  balloon         = 0
  scsihw          = "virtio-scsi-single"

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "32G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  serial {
    id = 0
  }

  ipconfig0  = "ip=192.168.68.20/24,gw=192.168.68.1"
  nameserver = "8.8.8.8 1.1.1.1"
  ciuser     = var.ci_user
  cipassword = var.ci_passwd
  sshkeys    = var.vm_ssh_key
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
}

resource "proxmox_vm_qemu" "k3s-worker" {
  count           = 2
  name            = "k3s-worker-${count.index + 1}"
  desc            = "Kubernetes Worker Node"
  target_node     = "pve"
  agent           = 1
  tags            = "K3s"
  vmid            = "400${count.index +1}" 
  clone           = "ubuntu-20.04-cloud-init-template"
  full_clone      = true
  onboot          = true
  automatic_reboot= true
  qemu_os         = "l26"
  cores           = 2
  sockets         = 1
  cpu_type        = "host"
  memory          = 4096
  balloon         = 0
  scsihw          = "virtio-scsi-single"

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "32G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  serial {
    id = 0
  }

  ipconfig0  = "ip=192.168.68.2${count.index +1}/24,gw=192.168.68.1"
  nameserver = "8.8.8.8 1.1.1.1"
  ciuser     = var.ci_user
  cipassword = var.ci_passwd
  sshkeys    = var.vm_ssh_key
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
}

# Variables should be defined separately in variables.tf
# Example for variables.tf:
# variable "ci_user" {}
# variable "ci_passwd" {}
# variable "vm_ssh_key" {}
