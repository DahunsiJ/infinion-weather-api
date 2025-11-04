# terraform/modules/aks/variables.tf
variable "aks_name" {
  description = "AKS cluster name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where AKS will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Naming prefix"
  type        = string
  default     = ""
}

variable "node_count" {
  description = "AKS node count"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "ssh_public_key" {
  description = "SSH public key for Linux nodes"
  type        = string
  default     = ""
}

# expect full resource id for ACR to assign role "AcrPull"
variable "acr_resource_id" {
  description = "Full resource id of ACR (used as scope for AcrPull role assignment)"
  type        = string
  default     = ""
}

variable "acr_login_server" {
  description = "ACR login server e.g. myacr.azurecr.io"
  type        = string
  default     = ""
}
