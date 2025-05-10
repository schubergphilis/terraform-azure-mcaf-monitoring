output "storage_account_id" {
  value = length(module.storage_account) > 0 ? module.storage_account[0].id : null
}

output "resource_group_id" {
  description = "ID of the Resource Group created by the module"
  value       = azurerm_resource_group.this.id
}