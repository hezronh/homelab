resource "proxmox_vm_qemu" "cloudinit-test" {
    name = "test-vm"
    desc = "Testing Terraform and cloud-init"
    depends_on = [ null_resource.cloud_init_test1 ]
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"

    # The template name to clone this vm from
    clone = "template-ubuntu-2204"
    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    memory = 2048
    scsihw = "virtio-scsi-single"

    # Setup the disk
    disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "containers-and-vms"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                  size     = "32G"
                  storage  = "containers-and-vms"
                  discard  = true
                  iothread = true
                }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
        id =0
    }

    # Setup the ip address using cloud-init.
    boot = "order=scsi0"
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.68.80/24,gw=192.168.68.1,ip6=dhcp"
    skip_ipv6 = true

    lifecycle {
      ignore_changes = [
        ciuser,
        sshkeys,
        network
      ]
    }
    cicustom = "user=local:snippets/cloud_init_test1.yml"
}