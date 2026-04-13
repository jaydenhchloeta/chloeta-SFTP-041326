output "function_app_name" {
  description = "Function App name"
  value       = azurerm_linux_function_app.func.name
}

output "function_app_hostname" {
  description = "Function App default hostname"
  value       = azurerm_linux_function_app.func.default_hostname
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage.name
}
