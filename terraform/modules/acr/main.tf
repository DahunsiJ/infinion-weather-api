# terraform/modules/acr/main.tf
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false

  # If you need geo-replication later, use sku = "Premium" and configure per-provider docs.
  # For now we avoid unsupported attributes across provider versions.

  tags = merge(
    var.tags,
    {
      project = var.prefix
      env     = "assessment"
    }
  )
}
