# ── Resource Group ────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg_network" {
  name     = "rg-IT-sftp-network-eus"
  location = var.location
}

resource "azurerm_resource_group" "rg_security" {
  name     = "rg-IT-sftp-security-eus"
  location = var.location
}

# ── Public IP Addresses ───────────────────────────────────────────────────────
resource "azurerm_public_ip" "pip_afw" {
  name                = "pip-afw-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_security.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "pip_afw_mgmt" {
  name                = "pip-afw-mgmt-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_security.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "pip_bas" {
  name                = "pip-bas-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_security.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "pip_vnet" {
  name                = "vnet-IT-sftp-eus-IPv4"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ── Route Tables ──────────────────────────────────────────────────────────────
resource "azurerm_route_table" "rt_confidential" {
  name                = "rt-IT-sftp-confit-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
}

resource "azurerm_route_table" "rt_work" {
  name                = "rt-IT-sftp-wrk-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
}

# ── Network Security Group ────────────────────────────────────────────────────
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location

  security_rule {
    name                       = "Allow-SFTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ── Virtual Network & Subnets ─────────────────────────────────────────────────
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "subnet_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_firewall_cidr]
}

resource "azurerm_subnet" "subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_bastion_cidr]
}

resource "azurerm_subnet" "subnet_confidential" {
  name                 = "snet-IT-sftp-confidential-eus"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_confidential_cidr]
}

resource "azurerm_subnet" "subnet_work" {
  name                 = "snet-IT-sftp-work-eus"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_work_cidr]
}

resource "azurerm_subnet_network_security_group_association" "nsg_confidential" {
  subnet_id                 = azurerm_subnet.subnet_confidential.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_work" {
  subnet_id                 = azurerm_subnet.subnet_work.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_route_table_association" "rt_assoc_confidential" {
  subnet_id      = azurerm_subnet.subnet_confidential.id
  route_table_id = azurerm_route_table.rt_confidential.id
}

resource "azurerm_subnet_route_table_association" "rt_assoc_work" {
  subnet_id      = azurerm_subnet.subnet_work.id
  route_table_id = azurerm_route_table.rt_work.id
}

# ── Firewall Policy ───────────────────────────────────────────────────────────
resource "azurerm_firewall_policy" "fwp" {
  name                = "fwp-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_security.name
  location            = var.location
  sku                 = "Standard"
}

# ── Azure Firewall ────────────────────────────────────────────────────────────
resource "azurerm_firewall" "afw" {
  name                = "afw-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fwp.id
  zones               = ["1", "2", "3"]

  ip_configuration {
    name                 = "ipconfig-afw"
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = azurerm_public_ip.pip_afw.id
  }

  management_ip_configuration {
    name                 = "ipconfig-afw-mgmt"
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = azurerm_public_ip.pip_afw_mgmt.id
  }
}

# ── Azure Bastion ─────────────────────────────────────────────────────────────
resource "azurerm_bastion_host" "bas" {
  name                = "bas-IT-sftp-eus"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = var.location
  sku                 = "Standard"

  ip_configuration {
    name                 = "ipconfig-bas"
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bas.id
  }
}
