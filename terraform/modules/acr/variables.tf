# terraform/modules/acr/variables.tf
variable "resource_group_name" {
  description = "Resource group name where ACR will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "acr_name" {
  description = "ACR name (must be globally unique, lowercase)"
  type        = string
}

variable "sku" {
  description = "ACR SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

# added: allow module to consume prefix if the module's TF references it
variable "prefix" {
  description = "Naming prefix forwarded to module if used in tags or naming"
  type        = string
  default     = ""
}
