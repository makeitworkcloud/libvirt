terraform {
  # please don't pin terraform versions.
  # stating a required minimum version should be sufficient for most use cases.
  required_version = "> 1.3"

  backend "s3" {}

  # please don't pin provider versions unless there is a known bug being worked around.
  # please add comment-doc when pinning to reference upstream bugs/docs that show the reason for the pin.
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}

provider "libvirt" {
  uri = data.sops_file.secret_vars.data["libvirt_uri"]
}

provider "sops" {}
