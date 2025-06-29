<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.7.1 |
| <a name="provider_sops"></a> [sops](#provider\_sops) | n/a |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_domain.runner](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/domain) | resource |
| [libvirt_domain.template-server](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/domain) | resource |
| [libvirt_volume.runner](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [libvirt_volume.template-server](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [ssh_resource.runner](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [sops_file.secret_vars](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->