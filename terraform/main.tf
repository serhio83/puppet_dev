provider "libvirt" {
  uri = "qemu:///system"
}

# load cloud-init configuration
data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  count    = length(var.vm_names)
}

# create cloud-init disks
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit-${var.vm_names[count.index]}.iso"
  user_data = data.template_file.user_data[count.index].rendered
  pool      = "ssd"
  count     = length(var.vm_names)
}

# create base system
resource "libvirt_volume" "centos7_base" {
  name   = "centos7_base.qcow2"
  pool   = "ssd"
  source = "/mnt/qemu-images/CentOS-7-x86_64-GenericCloud.qcow2"
  format = "qcow2"
}

# create guests volumes
resource "libvirt_volume" "os_volume" {
  name           = "root-${var.vm_names[count.index]}.qcow2"
  pool           = "ssd"
  format         = "qcow2"
  base_volume_id = libvirt_volume.centos7_base.id
  count          = length(var.vm_names)
  size           = 53687091200
}

# create guests
resource "libvirt_domain" "centos_domain" {
  name   = "${var.vm_names[count.index]}"
  memory = "${var.memory}"
  vcpu   = "${var.vcpu}"

  network_interface {
    network_name   = "extbr0"
    wait_for_lease = "false"
  }

  disk {
    volume_id = element(libvirt_volume.os_volume.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  count = length(var.vm_names)

  provisioner "remote-exec" {
    inline = ["hostnamectl set-hostname ${var.vm_names[count.index]}"]
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

terraform {
  required_version = ">= 0.12"
}
