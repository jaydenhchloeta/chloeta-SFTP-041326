# ── Resource Groups ───────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg_sms_alert" {
  name     = "rg-IT-SMS-Alert"
  location = "eastus"
}

resource "azurerm_resource_group" "rg_email_alert" {
  name     = "rg-IT-email-Alert"
  location = "eastus"
}

# ── SMS Communication Service ─────────────────────────────────────────────────
resource "azurerm_communication_service" "sms_alerts" {
  name                = "Safety-SMS-Alerts"
  resource_group_name = azurerm_resource_group.rg_sms_alert.name
  data_location       = "United States"
}

# ── Email Communication Service ───────────────────────────────────────────────
resource "azurerm_email_communication_service" "email_alerts" {
  name                = "IT-Email-Alerts"
  resource_group_name = azurerm_resource_group.rg_email_alert.name
  data_location       = "United States"
}

resource "azurerm_email_communication_service_domain" "chloeta" {
  name              = "Chloeta.com"
  email_service_id  = azurerm_email_communication_service.email_alerts.id
  domain_management = "CustomerManaged"
}

resource "azurerm_email_communication_service_domain" "chloetadata" {
  name              = "chloetadata.com"
  email_service_id  = azurerm_email_communication_service.email_alerts.id
  domain_management = "CustomerManaged"
}
