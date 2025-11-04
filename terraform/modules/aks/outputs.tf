# terraform/modules/aks/outputs.tf


output "aks_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_id" {
  description = "AKS resource id"
  value       = azurerm_kubernetes_cluster.aks.id
}

# Kubelet identity object id (useful for role assignment verification)
# This attribute exists for managed identities in modern azurerm provider versions.
output "aks_kubelet_identity_object_id" {
  description = "Object id of the AKS kubelet identity (if available)"
  value       = try(azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id, "")
}
