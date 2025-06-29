resource "libvirt_volume" "template-server" {
  name = "template-server.qcow2"
  size = "21474836480" # 20 Gigabyte to byte
}

resource "libvirt_domain" "template-server" {
  name        = "template-server"
  description = "GitHub Actions self-hosted template-server"
  cpu {
    mode = "host-passthrough"
  }
  vcpu   = "1"
  memory = "4096"
  disk {
    file = data.sops_file.secret_vars.data["fedora_server_path"]
  }
  disk {
    volume_id = libvirt_volume.template-server.id
  }
  network_interface {
    network_name = "default"
  }
  network_interface {
    network_name = "internal"
  }
  graphics {
    type        = "vnc"
    listen_type = "none"
  }
  boot_device {
    dev = ["cdrom", "hd"]
  }
  depends_on = [libvirt_volume.template-server]
}

