# Create Ubuntu Base Template on Proxmox

## Goal
Create a lightweight, reusable Ubuntu VM template for easy cloning in my homelab.

---

## Steps

### 1. Download Ubuntu Cloud Image
```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

---

### 2. Create a new VM in Proxmox
```bash
qm create 9000 --name "ubuntu-base" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
```
- VM ID `9000` is used for templates.
- Adjust memory, CPU, and bridge (`vmbr0`) if needed.

---

### 3. Import the Cloud Image as a Disk
```bash
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
```
- Replace `local-lvm` with your storage if different.

---

### 4. Attach the Disk to the VM
```bash
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
```

---

### 5. Add a Cloud-Init Drive
```bash
qm set 9000 --ide2 local-lvm:cloudinit
```

---

### 6. Set Boot Options
```bash
qm set 9000 --boot c --bootdisk scsi0
```

---

### 7. Enable Serial Console
```bash
qm set 9000 --serial0 socket --vga serial0
```
- Necessary for cloud images to boot properly.

---

### 8. Set Basic Cloud-Init Settings (Optional)
```bash
qm set 9000 --ciuser ubuntu --cipassword yourpassword
qm set 9000 --ipconfig0 ip=dhcp
```
- Replace `yourpassword` with a safe initial password.

---

### 9. Convert the VM to a Template
```bash
qm template 9000
```

---

## Why Use Cloud Images and Cloud-Init?

- **Lightweight:** Cloud images are minimal, optimized for fast deployment.
- **Automation Ready:** Cloud-Init lets you inject user credentials, network settings, SSH keys, etc. at first boot without manual setup.
- **Standardized:** Using official Ubuntu images ensures consistency across environments.
- **Speed:** Cloning from a prepared template is much faster than installing an OS from ISO every time.
- **Best Practice:** This method follows typical DevOps and cloud platform standards (AWS, Azure, OpenStack).

---

## Notes
- This template can now be cloned instantly to create new VMs.
- Later automation (Ansible, Terraform) can use this base image.
- Cloud-Init allows setting IPs, users, and SSH keys automatically.

---

## To Do
- Create an Ansible playbook for post-clone configuration.
- Automate cloning process using Terraform and/or Ansible.