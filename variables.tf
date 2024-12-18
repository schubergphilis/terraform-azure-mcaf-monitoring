variable "resource_group" {
  description = "The name of the resource group in which to create the resources."
  type = object({
    name = string
  })
  default = {
    name = null
  }
  nullable = false
}

variable "location" {
  type = string

}

variable "log_analytics_workspace" {
  type = object({
    name                            = string
    allow_resource_only_permissions = optional(bool, false)
    sku                             = optional(string, "PerGB2018")
  })
}

variable "storage_account" {
  type = object({
    name                     = string
    account_replication_type = optional(string, "ZRS")
    access_tier              = optional(string, "Cool")
    log_retention_days       = optional(number, 90)
    snapshot_retention_days  = optional(number, 90)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 