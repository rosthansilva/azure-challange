module "azure-hub-spoke-module" {
  source            = "./mod/hub-e-spoke/"
  project           = var.project
  vnet_hub_cdir     = var.vnet_hub_cdir
  vnet_spoke_cdir   = var.vnet_spoke_cdir
  inbound-subnet    = var.inbound-subnet
  management-subnet = var.management-subnet
  shared-subnet     = var.shared-subnet
  public-subnet     = var.public-subnet
  private-subnet    = var.private-subnet
  database-subnet   = var.database-subnet
  streaming-subnet  = var.streaming-subnet
  tags              = var.tags
}