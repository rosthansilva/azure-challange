resource "azurerm_resource_group" "hub" {
  name     = local.rg_hub
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke" {
  name     = local.rg_spoke
  location = var.location
  tags     = var.tags
}


module "hub_network" {
  source              = "../azure-network-module"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  vnet_name           = "${local.vnet_hub_name}"
  address_space       = ["${var.vnet_hub_cdir}"]
  subnets = [
    {
      #Subnet onde ficará o fortgate 
      name : "inbound-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.inbound-subnet}"]
    },
    {
      #hostlinux na borda da rede
      name : "management-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.management-subnet}"]
    },
    {
      #hostlinux na borda da rede
      name : "shared-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.shared-subnet}"]
    }
  ]

  depends_on = [
    azurerm_resource_group.hub
  ]
}

module "spoke_network" {
  source              = "../azure-network-module"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  vnet_name           = "${local.vnet_spoke_name}"
  address_space       = ["${var.vnet_spoke_cdir}"]
  subnets = [
    {
      #Subnet onde ficará o fortgate 
      name : "public-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.public-subnet}"]
    },
    {
      #hostlinux na borda da rede
      name : "private-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.private-subnet}"]
    },
    {
      #hostlinux na borda da rede
      name : "database-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.database-subnet}"]
    },
    {
      #hostlinux na borda da rede
      name : "streaming-subnet-${var.location}-${var.project}"
      address_prefixes : ["${var.streaming-subnet}"]
    }
  ]

  depends_on = [
    azurerm_resource_group.spoke
  ]
}


#Este Modulo faz a conexão das duas venets sem precisar fazer duas chamadas
module "hub-spoke-peering" {
  source              = "../azure-netwwork-peering-module"
  #Vnet1
  vnet_1_name         = local.vnet_hub_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.hub.name
  
  #Vnet1
  vnet_2_name         = local.vnet_spoke_name
  vnet_2_id           = module.spoke_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.spoke.name
  
  #Peerings
  peering_name_1_to_2 = "HubToSpoke"
  peering_name_2_to_1 = "SpokeToHub"
}