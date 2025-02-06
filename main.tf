resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

resource "azurerm_log_analytics_workspace" "this" {
  name                            = var.log_analytics_workspace.name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  allow_resource_only_permissions = var.log_analytics_workspace.allow_resource_only_permissions
  sku                             = var.log_analytics_workspace.sku
  tags = merge(
    try(var.tags),
    try(var.log_analytics_workspace.tags),
    tomap({
      "Resource Type" = "Log Analytics Workspace"
    })
  )
}

module "storage_account" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-storage-account.git?ref=v0.5.1"
  count  = var.storage_account != null ? 1 : 0

  name                              = var.storage_account.name
  location                          = var.location
  resource_group_name               = azurerm_resource_group.this.name
  account_tier                      = var.storage_account.account_tier
  account_replication_type          = var.storage_account.account_replication_type
  account_kind                      = "StorageV2"
  infrastructure_encryption_enabled = var.storage_account.infrastructure_encryption_enabled
  cmk_key_vault_id                  = var.storage_account.cmk_key_vault_id
  cmk_key_name                      = var.storage_account.cmk_key_name
  system_assigned_identity_enabled  = var.storage_account.system_assigned_identity_enabled
  user_assigned_identities          = var.storage_account.user_assigned_identities
  immutability_policy               = var.storage_account.immutability_policy
  network_configuration             = var.storage_account.network_configuration
  storage_management_policy         = var.storage_account.storage_management_policy
  tags = merge(
    try(var.tags),
    try(var.storage_account.tags)
  )
}

resource "azurerm_log_analytics_data_export_rule" "this" {
  count = var.storage_account != null && try(var.storage_account.enable_law_data_export, false) ? 1 : 0

  name                    = "Export-To-Storage"
  resource_group_name     = azurerm_resource_group.this.name
  workspace_resource_id   = azurerm_log_analytics_workspace.this.id
  destination_resource_id = module.storage_account[0].id
  table_names             = local.log_analytics_table_names
  enabled                 = true
}
