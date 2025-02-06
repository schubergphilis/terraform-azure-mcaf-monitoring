variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "location" {
  type = string

}

variable "log_analytics_workspace" {
  type = object({
    name                            = string
    allow_resource_only_permissions = optional(bool, false)
    sku                             = optional(string, "PerGB2018")
    tags                            = optional(map(string), {})
  })
}

variable "storage_account" {
  type = object({
    name                              = string
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "ZRS")
    access_tier                       = optional(string, "Cool")
    infrastructure_encryption_enabled = optional(bool, true)
    cmk_key_vault_id                  = optional(string, null)
    cmk_key_name                      = optional(string, null)
    system_assigned_identity_enabled  = optional(bool, false)
    user_assigned_identities          = optional(list(string), [])
    enable_law_data_export            = optional(bool, false)
    immutability_policy = optional(object({
      state                         = optional(string, "Unlocked")
      allow_protected_append_writes = optional(bool, true)
      period_since_creation_in_days = optional(number, 14)
    }), null)
    storage_management_policy = optional(object({
      blob_delete_retention_days      = optional(number, 90)
      container_delete_retention_days = optional(number, 90)
      move_to_cool_after_days         = optional(number, null)
      move_to_cold_after_days         = optional(number, null)
      move_to_archive_after_days      = optional(number, null)
      delete_after_days               = optional(number, null)
    }), {})
    network_configuration = optional(object({
      https_traffic_only_enabled      = optional(bool, true)
      allow_nested_items_to_be_public = optional(bool, false)
      public_network_access_enabled   = optional(bool, false)
      default_action                  = optional(string, "Deny")
      virtual_network_subnet_ids      = optional(list(string), [])
      ip_rules                        = optional(list(string), [])
      bypass                          = optional(list(string), ["AzureServices"])
    }), {})
    tags                            = optional(map(string), {})
  })
  validation {
    condition     = var.boot_diag_storage_account.storage_management_policy.move_to_archive_after_days != null && contains(["LRS", "GRS", "RAGRS"], var.boot_diag_storage_account.account_replication_type) || var.boot_diag_storage_account.storage_management_policy.move_to_archive_after_days == null
    error_message = "account_replication_type must be either 'LRS', 'GRS' or 'RAGRS' when archive tiering is enabled"
  }
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 