terraform {
  required_providers {
    proxmox             = {
    source            = "telmate/proxmox"
    version           = "3.0.1-rc6"
    }
  }

  required_version = "> 1.8.0"
}

resource "proxmox_vm_qemu" "template" {
  count                 = 1
  name                  = "template"
  target_node           = var.target_node

  clone                 = var.template_name_1
  full_clone            = true

  agent                 = 1
  os_type               = "Linux"
  cores                 = 1
  sockets               = 1
  cpu_type              = "host"
  memory                = 1024
  scsihw                = "virtio-scsi-pci"
  bootdisk              = "scsi0"

  disk {
    slot                = "scsi0"
    type                = "disk"
    storage             = "VMs"
    size                = "30G"
    iothread            = true
  }

  network {
    id                  = 0
    model               = "virtio"
    bridge              = "vmbr0"
  }

  lifecycle {
    ignore_changes      = [
    network,
    ]
  }
}
