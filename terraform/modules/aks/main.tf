# terraform/modules/aks/main.tf (AKS resource block updated)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "nodepool"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    type       = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  # Use boolean flag for RBAC
  role_based_access_control_enabled = true

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    # provider expects lowercase enum values
    outbound_type = "loadBalancer"
  }

  tags = {
    project = var.prefix
    env     = "assessment"
  }
}
