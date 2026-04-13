output "vnet_id" {
  description = "SFTP virtual network ID"
  value       = module.sftp_network.vnet_id
}

output "law_id" {
  description = "Log Analytics workspace ID"
  value       = module.sftp_security.law_id
}
