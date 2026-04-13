variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_confidential_id" {
  description = "Confidential subnet ID"
  type        = string
}

variable "subnet_work_id" {
  description = "Work subnet ID"
  type        = string
}

variable "vm_admin_username" {
  description = "Admin username for all VMs"
  type        = string
}

variable "vm_admin_ssh_public_key" {
  description = "SSH public key for all VMs"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "VM SKU size"
  type        = string
}

variable "vm_image" {
  description = "OS image reference"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "law_id" {
  description = "Log Analytics workspace ID for Azure Monitor extension"
  type        = string
}
