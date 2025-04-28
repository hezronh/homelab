resource "proxmox_vm_qemu" "k3s-master" {
 
 # -- General settings

 name = "k3s-master"
 desc = "Kubernetes Master Node"
 agent = 1  # <-- (Optional) Enable QEMU Guest Agent
 target_node = "pve"  # <-- Change to the name of your Proxmox node (if you have multiple nodes)
 tags = "K3s"
 vmid = "4000"

 # -- Template settings

 clone = "ubuntu-20.04-cloud-init-template"  # <-- Change to the name of the template or VM you want to clone
 full_clone = true  # <-- (Optional) Set to "false" to create a linked clone

 # -- Boot Process

 onboot = true 
 startup = ""  # <-- (Optional) Change startup and shutdown behavior
 automatic_reboot = false  # <-- Automatically reboot the VM after config change

 # -- Hardware Settings

 qemu_os = "other"
 cores = 2
 sockets = 1
 cpu_type = "host"
 memory = 6144
 balloon = 0  # <-- (Optional) Minimum memory of the balloon device, set to 0 to disable ballooning
 

 # -- Network Settings

 network {
   id     = 0  # <-- ! required since 3.x.x
   bridge = "vmbr0"
   model  = "virtio"
 }

 # -- Disk Settings
 
 scsihw = "virtio-scsi-single"  # <-- (Optional) Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
 
 disks {  # <-- ! changed in 3.x.x
   ide {
     ide0 {
       cloudinit {
         storage = "local-lvm"
       }
     }
   }
   virtio {
     virtio0 {
       disk {
         storage = "local-lvm"
         size = "20G"  # <-- Change the desired disk size, ! since 3.x.x size change will trigger a disk resize
         iothread = true  # <-- (Optional) Enable IOThread for better disk performance in virtio-scsi-single
         replicate = false  # <-- (Optional) Enable for disk replication
       }
     }
   }
 }

 # -- Cloud Init Settings

ipconfig0 = "ip=192.168.68.22/24,gw=192.168.68.1"  # <-- Change to your desired IP configuration
 nameserver = "8.8.8.8 1.1.1.1"  # <-- Change to your desired DNS server
 ciuser = var.ci_user  # <-- Change to your desired username
 cipassword = var.ci_passwd
 sshkeys = var.vm_ssh_key  # <-- (Optional) Change to your public SSH key
}

resource "proxmox_vm_qemu" "k3s-worker" {
 count = 1
 name = "k3s-worker-${count.index + 1}"
 desc = "Kubernetes worker Node"
 agent = 1  # <-- (Optional) Enable QEMU Guest Agent
 target_node = "pve"  # <-- Change to the name of your Proxmox node (if you have multiple nodes)
 tags = "K3s"
 vmid = "300${count.index + 1}"

 # -- Template settings

 clone = "ubuntu-20.04-cloud-init-template"  # <-- Change to the name of the template or VM you want to clone
 full_clone = true  # <-- (Optional) Set to "false" to create a linked clone

 # -- Boot Process

 onboot = true 
 startup = ""  # <-- (Optional) Change startup and shutdown behavior
 automatic_reboot = false  # <-- Automatically reboot the VM after config change

 # -- Hardware Settings

 qemu_os = "other"
 cores = 2
 sockets = 1
 cpu_type = "host"
 memory = 4096
 balloon = 0  # <-- (Optional) Minimum memory of the balloon device, set to 0 to disable ballooning
 

 # -- Network Settings

 network {
   id     = 0  # <-- ! required since 3.x.x
   bridge = "vmbr0"
   model  = "virtio"
 }

 # -- Disk Settings
 
 scsihw = "virtio-scsi-single"  # <-- (Optional) Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
 
 disks {  # <-- ! changed in 3.x.x
   ide {
     ide0 {
       cloudinit {
         storage = "local-lvm"
       }
     }
   }
   virtio {
     virtio0 {
       disk {
         storage = "local-lvm"
         size = "20G"  # <-- Change the desired disk size, ! since 3.x.x size change will trigger a disk resize
         iothread = true  # <-- (Optional) Enable IOThread for better disk performance in virtio-scsi-single
         replicate = false  # <-- (Optional) Enable for disk replication
       }
     }
   }
 }

 # -- Cloud Init Settings

 ipconfig0 = "ip=192.168.68.20${count.index + 1}/24,gw=192.168.68.1"  # <-- Change to your desired IP configuration
 nameserver = "8.8.8.8 1.1.1.1"  # <-- Change to your desired DNS server
 ciuser = var.ci_user  # <-- Change to your desired username
 cipassword = var.ci_passwd
 sshkeys = var.vm_ssh_key  # <-- (Optional) Change to your public SSH key
}