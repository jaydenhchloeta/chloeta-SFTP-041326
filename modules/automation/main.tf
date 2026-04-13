# ── Resource Group ────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg_automation" {
  name     = "rg-IT-automation"
  location = var.location
}

# ── Storage Account ───────────────────────────────────────────────────────────
resource "azurerm_storage_account" "storage" {
  name                     = "rgitautomation8d56"
  resource_group_name      = azurerm_resource_group.rg_automation.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version = "TLS1_2"
}

# ── App Service Plan (Flex Consumption) ───────────────────────────────────────
resource "azurerm_service_plan" "asp" {
  name                = "ASP-rgITautomation-87f9"
  resource_group_name = azurerm_resource_group.rg_automation.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "FC1"
}

# ── Application Insights ──────────────────────────────────────────────────────
resource "azurerm_application_insights" "app_insights" {
  name                = "Safety-Communication-Func"
  resource_group_name = azurerm_resource_group.rg_automation.name
  location            = var.location
  application_type    = "web"
}

# ── Linux Function App ────────────────────────────────────────────────────────
resource "azurerm_linux_function_app" "func" {
  name                       = "Safety-Communication-Func"
  resource_group_name        = azurerm_resource_group.rg_automation.name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  site_config {
    application_insights_key               = azurerm_application_insights.app_insights.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.app_insights.connection_string
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }
}
