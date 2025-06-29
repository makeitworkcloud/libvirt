resource "libvirt_volume" "runner" {
  name = "runner.qcow2"
  size = "21474836480" # 20 Gigabyte to byte
}

resource "libvirt_domain" "runner" {
  name        = "runner"
  description = "GitHub Actions self-hosted runner"
  cpu {
    mode = "host-passthrough"
  }
  vcpu   = "1"
  memory = "8192"
  disk {
    file = data.sops_file.secret_vars.data["fedora_server_path"]
  }
  disk {
    volume_id = libvirt_volume.runner.id
  }
  network_interface {
    network_name = "default"
  }
  network_interface {
    network_name = "internal"
  }
  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "0.0.0.0"
    autoport       = true
  }
  boot_device {
    dev = ["cdrom", "hd"]
  }
  depends_on = [libvirt_volume.runner]
}

