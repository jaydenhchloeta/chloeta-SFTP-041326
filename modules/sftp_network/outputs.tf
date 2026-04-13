output "vnet_id" {
  description = "SFTP virtual network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_confidential_id" {
  description = "Confidential subnet ID"
  value       = azurerm_subnet.subnet_confidential.id
}

output "subnet_work_id" {
  description = "Work subnet ID"
  value       = azurerm_subnet.subnet_work.id
}

output "nsg_id" {
  description = "SFTP NSG ID"
  value       = azurerm_network_security_group.nsg.id
}

output "rg_security_name" {
  description = "Security resource group name"
  value       = azurerm_resource_group.rg_security.name
}

output "rg_security_id" {
  description = "Security resource group ID"
  value       = azurerm_resource_group.rg_security.id
}
