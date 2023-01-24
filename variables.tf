variable "resource_group" {
  description = "Azure resource group to deploy into."

  type = object({
    name     = string
    location = string
  })
}

variable "resource_name_prefix" {
  default     = "dev"
  description = "Prefix applied to resource names"
  type        = string

  validation {
    condition     = length(var.resource_name_prefix) < 16 && (replace(var.resource_name_prefix, " ", "") == var.resource_name_prefix)
    error_message = "The resource_name_prefix value must be fewer than 16 characters long and may not contain spaces."
  }
}

variable "shared_san" {
  description = "Shared server name to add to the certificates."
  type        = string
}

variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}
