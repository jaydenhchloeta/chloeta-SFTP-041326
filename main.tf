module "sftp_network" {
  source = "github.com/jaydendh/chloeta-SFTP-terraform-module//azure/sftp_network?ref=main"

  location                 = var.location_eus
  vnet_address_space       = var.vnet_address_space
  subnet_firewall_cidr     = var.subnet_firewall_cidr
  subnet_bastion_cidr      = var.subnet_bastion_cidr
  subnet_confidential_cidr = var.subnet_confidential_cidr
  subnet_work_cidr         = var.subnet_work_cidr
}

# Security is created first — VMs reference the LAW ID for AMA extension
module "sftp_security" {
  source = "github.com/jaydendh/chloeta-SFTP-terraform-module//azure/sftp_security?ref=main"

  location             = var.location_eus
  rg_confidential_name = "rg-IT-sftp-confidential-eus"
}

module "sftp_vms" {
  source = "github.com/jaydendh/chloeta-SFTP-terraform-module//azure/sftp_vms?ref=main"

  location                = var.location_eus
  subnet_confidential_id  = module.sftp_network.subnet_confidential_id
  subnet_work_id          = module.sftp_network.subnet_work_id
  vm_admin_username       = var.vm_admin_username
  vm_admin_ssh_public_key = var.vm_admin_ssh_public_key
  vm_size                 = var.vm_size
  vm_image                = var.vm_image
  law_id                  = module.sftp_security.law_id

  depends_on = [module.sftp_network, module.sftp_security]
}
