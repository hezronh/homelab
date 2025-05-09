resource "proxmox_vm_qemu" "create-vm" {
  count       = 2
  vmid        = "30${count.index +1}"
  name        = "hftm-vm-ubuntu-${count.index +1}"
  target_node = "pve"
  tags        = "VM,Services"
  agent       = 1
  cores       = 2
  memory      = 2048
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone_id       = 8000 # The ID of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=192.168.68.7${count.index +1}/24,gw=192.168.68.1,ip6=dhcp"
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
