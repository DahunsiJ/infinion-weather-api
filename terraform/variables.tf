# terraform/variables.tf (root)
variable "prefix" {
  description = "Project prefix for resource naming (lowercase, alphanumeric)"
  type        = string
  default     = "infinionwh"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "If empty, a resource group name will be computed from prefix. Set to existing RG when re-using one."
  type        = string
  default     = "dahunsijustus06gmail.com"
}


variable "acr_suffix" {
  description = "Optional suffix to ensure ACR name uniqueness (lowercase)."
  type        = string
  default     = ""
}

variable "node_count" {
  description = "AKS node count for default pool"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "AKS VM size"
  type        = string
  default     = "Standard_B2s"
}

# Backend storage variables (if you want to parameterize remote backend later)
variable "tfstate_rg" {
  type    = string
  default = "tfstate-rg"
}
variable "tfstate_account" {
  type    = string
  default = "infinionwhstate"
}
variable "tfstate_container" {
  type    = string
  default = "tfstate"
}

variable "ssh_public_key" {
  description = "Optional SSH public key for Linux nodes (leave empty to skip)"
  type        = string
  default     = ""
}
