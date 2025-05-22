output "storage_account_id" {
  value = length(module.storage_account) > 0 ? module.storage_account[0].id : null
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace created by the module"
  value       = azurerm_log_analytics_workspace.this.id
}

output "resource_group_id" {
  description = "ID of the Resource Group created by the module"
  value       = azurerm_resource_group.this.id
}