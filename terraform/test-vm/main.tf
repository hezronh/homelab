resource "proxmox_vm_qemu" "test-vm" {
  name         = "test-vm"
  desc         = "Testing Terraform and cloud-init"
  target_node  = "pve"
  clone        = "ubuntu-20.04-cloud-init-template"
  full_clone = true
  agent        = 1
  os_type      = "cloud-init" # Kan blijven staan voor compatibiliteit
  cores        = 2
  memory       = 2048
  scsihw       = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk {
          size     = "32G"
          storage  = "local-lvm"
          discard  = true
          iothread = true
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    id     = 0
  }

  lifecycle {
    ignore_changes = [
        cicustom,
        ciuser,
        cipassword,
        ipconfig0,
        sshkeys,
        disk
    ]
  }

  # GEEN cicustom meer!
}

resource "proxmox_vm_qemu" "cloudinit-example" {
  vmid        = 300
  name        = "test-terraform0"
  target_node = "pve"
  agent       = 1
  cores       = 2
  memory      = 1024
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = "ubuntu-20.04-cloud-init-template" # The name of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=192.168.68.90/24,gw=192.168.68.1,ip6=dhcp"
  skip_ipv6  = true
  ciuser     = var.ci_user
  cipassword = var.ci_passwd
  sshkeys    = var.vm_ssh_key

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "local-lvm"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = "32G" 
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}
