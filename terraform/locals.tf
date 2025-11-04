# terraform/locals.tf
locals {
  # Use explicit resource_group_name var if provided; else compute one from prefix.
  # Use trimspace() to strip whitespace safely.
  rg_name = length(trimspace(var.resource_group_name)) > 0 ? var.resource_group_name : "${var.prefix}-rg"

  # ACR name: must be lowercase and globally unique; append optional suffix
  acr_name = lower("${var.prefix}acr${var.acr_suffix}")

  # AKS cluster name
  aks_cluster_name = "${var.prefix}-aks"
}
