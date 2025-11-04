############################################
# terraform/main.tf

# # NOTE: Resource group is pre-created by Infinion. We intentionally DO NOT create it here.
# The data source in rg.tf will be used to reference the existing resource group:
# data.azurerm_resource_group.rg



################################################
# ACR module
################################################
module "acr" {
  source = "./modules/acr"

  # Use the resource group created above (or the data lookup if you prefer)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  # pass the computed ACR name from locals to module
  acr_name = local.acr_name

  sku = "Standard"
  tags = {
    project = var.prefix
    env     = "assessment"
  }
}

################################################
# AKS module
################################################
module "aks" {
  source = "./modules/aks"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  # map to the module variable name (we set aks_name in modules/aks/variables.tf)
  aks_name   = local.aks_cluster_name
  dns_prefix = local.aks_cluster_name

  prefix       = var.prefix
  node_count   = var.node_count
  node_vm_size = var.node_vm_size

  # supply ssh_public_key if you have one; default is empty if you didn't set it
  ssh_public_key = var.ssh_public_key

  # ACR outputs: pass the ACR resource id & login server so the module can assign AcrPull
  acr_resource_id  = module.acr.acr_id
  acr_login_server = module.acr.acr_login_server

  # tags can be forwarded if used in module
  # tags = { project = var.prefix, env = "assessment" }
}

################################################
# Expose some handy outputs at root level
################################################
output "acr_login_server" {
  description = "ACR login server for pushing images"
  value       = module.acr.acr_login_server
}

output "acr_id" {
  description = "ACR resource id"
  value       = module.acr.acr_id
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}
