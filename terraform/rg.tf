# terraform/rg.tf
# Reference the existing resource group; do not attempt to set location/tags here.
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
