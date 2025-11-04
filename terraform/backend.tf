# terraform {
#   backend "azurerm" {
#     resource_group_name  = "tfstate-rg"
#     storage_account_name = "infinonwhstate"
#     container_name       = "tfstate"
#     key                  = "infinionwh.terraform.tfstate"
#   }
# }



terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}



