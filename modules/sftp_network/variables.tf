variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the SFTP VNet"
  type        = string
}

variable "subnet_firewall_cidr" {
  description = "AzureFirewallSubnet CIDR"
  type        = string
}

variable "subnet_bastion_cidr" {
  description = "AzureBastionSubnet CIDR"
  type        = string
}

variable "subnet_confidential_cidr" {
  description = "Confidential SFTP VM subnet CIDR"
  type        = string
}

variable "subnet_work_cidr" {
  description = "Work SFTP VM subnet CIDR"
  type        = string
}
