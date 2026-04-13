variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "location_eus" {
  description = "Primary East US location"
  type        = string
  default     = "eastus"
}

# ── Network CIDRs ─────────────────────────────────────────────────────────────
variable "vnet_address_space" {
  description = "Address space for the SFTP virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_firewall_cidr" {
  description = "AzureFirewallSubnet — must be /26 or larger"
  type        = string
  default     = "10.0.0.0/26"
}

variable "subnet_bastion_cidr" {
  description = "AzureBastionSubnet — must be /26 or larger"
  type        = string
  default     = "10.0.1.0/26"
}

variable "subnet_confidential_cidr" {
  description = "Subnet for confidential SFTP VMs"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_work_cidr" {
  description = "Subnet for work SFTP VMs"
  type        = string
  default     = "10.0.3.0/24"
}

# ── VM credentials ────────────────────────────────────────────────────────────
variable "vm_admin_username" {
  description = "Admin username for all SFTP VMs"
  type        = string
  default     = "azureadmin"
}

variable "vm_admin_password" {
  description = "Admin password for all SFTP VMs (sourced from Keeper)"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "VM size for SFTP virtual machines"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_image" {
  description = "OS image for SFTP virtual machines"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
