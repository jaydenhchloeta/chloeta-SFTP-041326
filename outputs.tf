output "vnet_id" {
  description = "SFTP virtual network ID"
  value       = module.sftp_network.vnet_id
}

output "law_id" {
  description = "Log Analytics workspace ID"
  value       = module.sftp_security.law_id
}

output "function_app_name" {
  description = "Safety Communication Function App name"
  value       = module.automation.function_app_name
}

output "function_app_hostname" {
  description = "Safety Communication Function App default hostname"
  value       = module.automation.function_app_hostname
}
