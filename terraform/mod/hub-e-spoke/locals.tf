locals {
  vnet_hub_name =  "vnet-hub-${var.location}-${var.project}"
  vnet_spoke_name =  "vnet-spoke-${var.location}-${var.project}"
  rg_hub =  "rg-hub-${var.location}-${var.project}"
  rg_spoke =  "rg-spoke-${var.location}-${var.project}"
}