output "law_id" {
  description = "Log Analytics workspace resource ID"
  value       = azurerm_log_analytics_workspace.law.id
}

output "law_workspace_id" {
  description = "Log Analytics workspace GUID"
  value       = azurerm_log_analytics_workspace.law.workspace_id
}

output "dce_id" {
  description = "Data Collection Endpoint resource ID"
  value       = azurerm_monitor_data_collection_endpoint.dce.id
}

output "dcr_id" {
  description = "Data Collection Rule resource ID"
  value       = azurerm_monitor_data_collection_rule.dcr.id
}
