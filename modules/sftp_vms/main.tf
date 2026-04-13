# ── Resource Groups ───────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg_confidential" {
  name     = "rg-IT-sftp-confidential-eus"
  location = var.location
}

resource "azurerm_resource_group" "rg_work" {
  name     = "rg-IT-sftp-work-eus"
  location = var.location
}

# ── SSH Public Key ────────────────────────────────────────────────────────────
resource "azurerm_ssh_public_key" "conf_key" {
  name                = "vm-IT-sftp-conf-eus_key"
  resource_group_name = azurerm_resource_group.rg_confidential.name
  location            = var.location
  public_key          = var.vm_admin_ssh_public_key
}

# ── Network Interfaces ────────────────────────────────────────────────────────
resource "azurerm_network_interface" "conf_nic" {
  name                = "vm-it-sftp-conf-eus624_z1"
  resource_group_name = azurerm_resource_group.rg_confidential.name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_confidential_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "lm_nic" {
  name                = "vm-it-sftp-lm-eus404_z1"
  resource_group_name = azurerm_resource_group.rg_work.name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_work_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "zp_nic" {
  name                = "vm-it-sftp-zp-eus604_z1"
  resource_group_name = azurerm_resource_group.rg_work.name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_work_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ── Confidential SFTP VM ──────────────────────────────────────────────────────
resource "azurerm_linux_virtual_machine" "conf_vm" {
  name                  = "vm-IT-sftp-conf-eus"
  resource_group_name   = azurerm_resource_group.rg_confidential.name
  location              = var.location
  size                  = var.vm_size
  zone                  = "1"
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.conf_nic.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_admin_ssh_public_key
  }

  os_disk {
    name                 = "vm-IT-sftp-conf-eus_OsDisk_1"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }
}

# ── Work SFTP VMs ─────────────────────────────────────────────────────────────
resource "azurerm_linux_virtual_machine" "lm_vm" {
  name                  = "vm-IT-sftp-LM-eus"
  resource_group_name   = azurerm_resource_group.rg_work.name
  location              = var.location
  size                  = var.vm_size
  zone                  = "1"
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.lm_nic.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_admin_ssh_public_key
  }

  os_disk {
    name                 = "vm-IT-sftp-LM-eus_OsDisk_1"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }
}

resource "azurerm_linux_virtual_machine" "zp_vm" {
  name                  = "vm-IT-sftp-ZP-eus"
  resource_group_name   = azurerm_resource_group.rg_work.name
  location              = var.location
  size                  = var.vm_size
  zone                  = "1"
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.zp_nic.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_admin_ssh_public_key
  }

  os_disk {
    name                 = "vm-IT-sftp-ZP-eus_OsDisk_1"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }
}

# ── VM Access Extension (all three VMs) ───────────────────────────────────────
resource "azurerm_virtual_machine_extension" "conf_vm_access" {
  name                 = "enablevmAccess"
  virtual_machine_id   = azurerm_linux_virtual_machine.conf_vm.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "VMAccessForLinux"
  type_handler_version = "1.5"
}

resource "azurerm_virtual_machine_extension" "lm_vm_access" {
  name                 = "enablevmAccess"
  virtual_machine_id   = azurerm_linux_virtual_machine.lm_vm.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "VMAccessForLinux"
  type_handler_version = "1.5"
}

resource "azurerm_virtual_machine_extension" "zp_vm_access" {
  name                 = "enablevmAccess"
  virtual_machine_id   = azurerm_linux_virtual_machine.zp_vm.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "VMAccessForLinux"
  type_handler_version = "1.5"
}

# ── Azure Monitor Linux Agent (all three VMs) ─────────────────────────────────
resource "azurerm_virtual_machine_extension" "conf_ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.conf_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "lm_ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.lm_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "zp_ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.zp_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
