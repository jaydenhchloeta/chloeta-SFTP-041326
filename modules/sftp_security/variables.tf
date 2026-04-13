variable "location" {
  description = "Azure region"
  type        = string
}

variable "rg_confidential_name" {
  description = "Name of the confidential resource group (for DCE placement). The sftp_vms module creates this RG; pass the name as a string to avoid a circular dependency."
  type        = string
  default     = "rg-IT-sftp-confidential-eus"
}
