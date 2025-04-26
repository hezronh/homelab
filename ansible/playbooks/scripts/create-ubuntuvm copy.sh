#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
VM_ID=9000
VM_NAME="ubuntu-base"
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
STORAGE="local-lvm"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_FILE="jammy-server-cloudimg-amd64.img"

# Download Ubuntu Cloud Image if not already downloaded
if [ ! -f "$IMAGE_FILE" ]; then
  echo "Downloading Ubuntu Cloud Image..."
  wget $IMAGE_URL
else
  echo "Ubuntu Cloud Image already downloaded."
fi

# Create VM
echo "Creating VM..."
qm create $VM_ID --name "$VM_NAME" --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

# Import disk
echo "Importing disk..."
qm importdisk $VM_ID $IMAGE_FILE $STORAGE

# Attach disk to VM
echo "Attaching disk to VM..."
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${VM_ID}-disk-0

# Add Cloud-Init Drive
echo "Adding Cloud-Init drive..."
qm set $VM_ID --ide2 $STORAGE:cloudinit

# Set boot options
echo "Setting boot options..."
qm set $VM_ID --boot c --bootdisk scsi0

# Enable serial console
echo "Enabling serial console..."
qm set $VM_ID --serial0 socket --vga serial0

# Optional: Set default cloud-init settings
# You can adjust these settings as needed
DEFAULT_USER="ubuntu"
DEFAULT_PASSWORD="ubuntu"

echo "Setting basic Cloud-Init settings..."
qm set $VM_ID --ciuser $DEFAULT_USER --cipassword $DEFAULT_PASSWORD
qm set $VM_ID --ipconfig0 ip=dhcp

# Convert VM to template
echo "Converting VM to template..."
qm template $VM_ID


echo "Ubuntu Base Template creation completed successfully!"
