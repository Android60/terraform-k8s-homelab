# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "vm_name" {
  description = "The name of the VM that will be created"
  type        = string
  default     = "docker-host3.server"
}

variable "target_node" {
  description = "The node to use when creating VM"
  type        = string
  default     = "megaserver-proxmox"
}

variable "clone_template" {
  description = "The base VM from which to clone to create the new VM"
  type        = number
  default     = 212
}

variable "ssh_user" {
  description = "User to use for SSH"
  type        = string
  default     = "debian"
}

variable "disk_size" {
  description = "The size of the created disk"
  type        = number
  default     = "32"
}

variable "storage_pool" {
  description = "The name of the storage pool on which to store the disk."
  type        = string
  default     = "hdd_lvm"
}

variable "r410_vms" {
  description = "Map for VMs names and configuration"
  type        = map(any)
  default     = {}
}

variable "ibm_vms" {
  description = "Map for VMs names and configuration"
  type        = map(any)
  default     = {}
}

variable "r410_api_token" {
  description = "API token for the R410"
  type        = string
  default     = ""
}

variable "ibm_api_token" {
  description = "API token for IBM"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "remote_exec" {
  description = "Script to run"
  type        = list(string)
  default     = ["echo \"Hello, World from $(uname -smp)\""]
}

variable "description" {
  description = "The description for the VM that will be created"
  type        = string
  default     = "Managed by Terraform"
}

variable "env" {
  description = "Environment for VM name"
  type        = string
  default     = "stage"
}

locals {
  vm_name = "${var.env}.${var.vm_name}"
}
