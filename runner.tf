resource "libvirt_volume" "runner" {
  name           = "runner.qcow2"
  base_volume_id = libvirt_volume.template-server.id
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
    volume_id = libvirt_volume.runner.id
  }
  network_interface {
    network_name = "default"
  }
  network_interface {
    bridge = "nm-bridge"
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

resource "ssh_resource" "runner" {
  host         = data.sops_file.secret_vars.data["ssh_host"]
  bastion_host = data.sops_file.secret_vars.data["ssh_bastion_host"]
  user         = data.sops_file.secret_vars.data["ssh_user"]
  private_key  = data.sops_file.secret_vars.data["ssh_private_key"]

  commands = [
    "sudo dnf install docker -y",
    "sudo systemctl enable docker",
    "sudo usermod -aG docker ${data.sops_file.secret_vars.data["ssh_user"]}",
    "sudo hostnamectl set-hostname runner",
    "mkdir actions-runner",
    "cd actions-runner && curl -o ./actions-runner-linux-x64-2.325.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz",
    "cd actions-runner && echo \"5020da7139d85c776059f351e0de8fdec753affc9c558e892472d43ebeb518f4  ./actions-runner-linux-x64-2.325.0.tar.gz\" | shasum -a 256 -c",
    "cd actions-runner && tar xzf ./actions-runner-linux-x64-2.325.0.tar.gz",
    "cd actions-runner && ./config.sh --name runner-libvirt --labels libvirt --url https://github.com/makeitworkcloud --token ${data.sops_file.secret_vars.data["github_token"]}",
    "cd actions-runner && sudo chcon system_u:object_r:usr_t:s0 ./svc.sh",
    "cd actions-runner && sudo ./svc.sh install",
    "cd actions-runner && sudo chcon system_u:object_r:usr_t:s0 ./runsvc.sh",
    "sudo nmcli con mod ens4 ipv4.addresses ${data.sops_file.secret_vars.data["runner_ip_addr"]}",
    "sudo reboot"
  ]
  depends_on = [libvirt_domain.runner]
}

