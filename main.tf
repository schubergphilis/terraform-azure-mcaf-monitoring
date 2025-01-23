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
    tomap({
      "Resource Type" = "Log Analytics Workspace"
    })
  )
}

module "storage_account" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-storage-account.git?ref=v0.2.0"
  count  = var.storage_account != null ? 1 : 0

  name                              = var.storage_account.name
  location                          = var.location
  resource_group_name               = azurerm_resource_group.this.name
  account_tier                      = var.storage_account.account_tier
  account_replication_type          = var.storage_account.account_replication_type
  account_kind                      = "StorageV2"
  access_tier                       = var.storage_account.access_tier
  public_network_access_enabled     = var.storage_account.public_network_access_enabled
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = var.storage_account.infrastructure_encryption_enabled
  cmk_key_vault_id                  = var.storage_account.cmk_key_vault_id
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Storage Account"
    })
  )
}

resource "azurerm_storage_management_policy" "this" {
  count = var.storage_account != null ? 1 : 0

  # TODO: Expand these rules with tiering settings
  storage_account_id = module.storage_account[0].id
  rule {
    name    = "Log retention Days"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.storage_account.log_retention_days
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.storage_account.snapshot_retention_days
      }
    }
  }
}

resource "azurerm_log_analytics_data_export_rule" "this" {
  count = var.storage_account != null ? 1 : 0

  name                    = "Export-To-Storage"
  resource_group_name     = azurerm_resource_group.this.name
  workspace_resource_id   = azurerm_log_analytics_workspace.this.id
  destination_resource_id = module.storage_account[0].id
  table_names             = local.log_analytics_table_names
  enabled                 = true
}