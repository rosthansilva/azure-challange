variable "project" {

}

variable "vnet_hub_cdir" {

}

variable "vnet_spoke_cdir" {

}

variable "inbound-subnet" {

}

variable "management-subnet" {

}


variable "shared-subnet" {

}

variable "public-subnet" {

}

variable "private-subnet" {

}
variable "database-subnet" {

}

variable "streaming-subnet" {

}

variable "tags" {
  type = map(any)
}

variable "location" {
  default = "eastus"

}