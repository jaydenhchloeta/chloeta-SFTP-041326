output "sms_service_id" {
  description = "Communication Service resource ID"
  value       = azurerm_communication_service.sms_alerts.id
}

output "email_service_id" {
  description = "Email Communication Service resource ID"
  value       = azurerm_email_communication_service.email_alerts.id
}
