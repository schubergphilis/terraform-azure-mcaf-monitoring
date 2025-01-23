variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
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
    name                              = string
    public_network_access_enabled     = optional(bool, false)
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "ZRS")
    access_tier                       = optional(string, "Cool")
    log_retention_days                = optional(number, null)
    move_to_cold_after_days           = optional(number, null)
    move_to_archive_after_days        = optional(number, null)
    snapshot_retention_days           = optional(number, 90)
    infrastructure_encryption_enabled = optional(bool, true)
    cmk_key_vault_id                  = optional(string, null)
    cmk_key_name                      = optional(string, null)
    system_assigned_identity_enabled  = optional(bool, false)
    user_assigned_identities          = optional(list(string), [])
    enable_law_data_export            = optional(bool, false)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 