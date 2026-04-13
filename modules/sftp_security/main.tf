# ── Resource Group ────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg_security" {
  name     = "rg-IT-sftp-security-eus"
  location = var.location
}

# ── Log Analytics Workspace ───────────────────────────────────────────────────
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_security.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

# ── Microsoft Sentinel ────────────────────────────────────────────────────────
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}

# ── Data Collection Endpoint ──────────────────────────────────────────────────
# Placed in the confidential RG (rg_confidential_name is passed to avoid a
# circular dependency with sftp_vms, which needs law_id from this module).
resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = "dce-IT-sftp-eus"
  resource_group_name = var.rg_confidential_name
  location            = var.location
  kind                = "Linux"
}

# ── Data Collection Rule ──────────────────────────────────────────────────────
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                        = "dcr-IT-sftp-eus"
  resource_group_name         = azurerm_resource_group.rg_security.name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  kind                        = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "law-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["law-destination"]
  }

  data_sources {
    syslog {
      name           = "syslog-datasource"
      facility_names = ["auth", "authpriv", "cron", "daemon", "kern", "syslog", "user"]
      log_levels     = ["Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"]
      streams        = ["Microsoft-Syslog"]
    }
  }
}
