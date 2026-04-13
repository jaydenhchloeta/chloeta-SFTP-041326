output "rg_confidential_name" {
  description = "Confidential resource group name"
  value       = azurerm_resource_group.rg_confidential.name
}

output "rg_confidential_id" {
  description = "Confidential resource group ID"
  value       = azurerm_resource_group.rg_confidential.id
}

output "conf_vm_id" {
  description = "Confidential SFTP VM resource ID"
  value       = azurerm_linux_virtual_machine.conf_vm.id
}

output "lm_vm_id" {
  description = "LM work SFTP VM resource ID"
  value       = azurerm_linux_virtual_machine.lm_vm.id
}

output "zp_vm_id" {
  description = "ZP work SFTP VM resource ID"
  value       = azurerm_linux_virtual_machine.zp_vm.id
}
