output "storage_account_id" {
  value = var.storage_account != null ? module.storage_account[0].id : null
}

output "resource_group_id" {
  description = "ID of the Resource Group created by the module"  
  value       = azurerm_resource_group.this.id
}