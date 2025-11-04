# terraform/modules/acr/outputs.tf
output "acr_id" {
  description = "Resource id of the created ACR"
  value       = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  description = "Login server for the ACR (e.g. myacr.azurecr.io)"
  value       = azurerm_container_registry.acr.login_server
}
