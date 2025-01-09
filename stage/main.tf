terraform {
  required_providers {
    proxmox = {
      source                = "bpg/proxmox"
      version               = "0.48.1"
      configuration_aliases = [proxmox.r410]
    }
    mikrotik = {
      source  = "ddelnano/mikrotik"
      version = "0.9.1"
    }

  }
}

provider "proxmox" {
  endpoint  = "https://r410-proxmox.server:8006/"
  api_token = var.r410_api_token # export TF_VAR_r410_api_token
  insecure  = true
  alias     = "r410"
}

provider "proxmox" {
  endpoint  = "https://ibm-x3200-prox1.lan:8006/"
  api_token = var.ibm_api_token # export TF_VAR_ibm_api_token
  insecure  = true
  alias     = "ibm"
}

provider "mikrotik" {
  # set MIKROTIK_HOST environment variable
  # export MIKROTIK_USER=user
  # export MIKROTIK_PASSWORD=pass
  tls      = false # Or set MIKROTIK_TLS environment variable
  insecure = true  # Or set MIKROTIK_INSECURE environment variable
}

module "proxmox_vm_r410" {
  providers = {
    proxmox = proxmox.r410
  }
  source         = "git::https://gitlab.myhomelab.xyz/terraform-modules/terraform-proxmox-modules.git//modules/vm-module/?ref=v0.1.5"
  for_each       = var.r410_vms
  name           = "${var.env}-${each.value.name}" # Name for new VM
  target_node    = "dell-r410"                     # Create VM on that node
  clone_template = var.clone_template              # Template to use when cloning VM
  remote_exec    = var.remote_exec                 # Script to execute on provisioning
  ssh_privkey    = file("~/.ssh/id_rsa")           # Private key to use when provisioning
  ssh_user       = var.ssh_user                    # SSH user to use
  ciuser         = var.ssh_user
  ssh_keys       = [trimspace(file("~/.ssh/id_rsa.pub"))]
  cores          = 2
  memory         = 4096
  storage_pool   = "local-lvm"
  disk_size      = var.disk_size
  tags           = ["stage", "terraform"]
  user           = " "
  nameserver     = ["192.168.100.1"]
  vlan           = null
}

module "proxmox_vm_ibm" {
  providers = {
    proxmox = proxmox.ibm
  }
  source         = "git::https://gitlab.myhomelab.xyz/terraform-modules/terraform-proxmox-modules.git//modules/vm-module/?ref=v0.1.5"
  for_each       = var.ibm_vms
  name           = "${var.env}-${each.value.name}" # Name for new VM
  target_node    = each.value.target_node          # Create VM on that node
  clone_template = each.value.clone_template       # Template to use when cloning VM
  remote_exec    = var.remote_exec                 # Script to execute on provisioning
  ssh_privkey    = file("~/.ssh/id_rsa")           # Private key to use when provisioning
  ssh_user       = var.ssh_user                    # SSH user to use
  ciuser         = var.ssh_user
  ssh_keys       = [trimspace(file("~/.ssh/id_rsa.pub"))]
  cores          = 2
  memory         = 4096
  storage_pool   = "local-lvm"
  disk_size      = var.disk_size
  tags           = ["stage", "terraform"]
  user           = " "
  nameserver     = ["192.168.100.1"]
  vlan           = null
}

# resource "null_resource" "ansible-provision-docker" {
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_user} -i ${module.proxmox_vm.ip_address}, ../../../../../modules/ansible/install-docker/main.yml"
#   }
#   triggers = {
#     ansible_playbook = filesha256("../../../../../modules/ansible/install-docker/main.yml")
#   }
#   depends_on = [
#     module.proxmox_vm
#   ]
# }

resource "mikrotik_dns_record" "proxmox_vm_r410" {
  for_each = module.proxmox_vm_r410
  name     = each.value.name
  address  = each.value.ip_address[0]
  ttl      = 86400
}

resource "mikrotik_dns_record" "proxmox_vm_ibm" {
  for_each = module.proxmox_vm_ibm
  name     = each.value.name
  address  = each.value.ip_address[0]
  ttl      = 86400
}

