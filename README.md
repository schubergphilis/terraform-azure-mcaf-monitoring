<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | github.com/schubergphilis/terraform-azure-mcaf-storage-account.git | immutability_policy |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_data_export_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | n/a | <pre>object({<br>    name                            = string<br>    allow_resource_only_permissions = optional(bool, false)<br>    sku                             = optional(string, "PerGB2018")<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the resources. | `string` | n/a | yes |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | n/a | <pre>object({<br>    name                              = string<br>    public_network_access_enabled     = optional(bool, false)<br>    account_tier                      = optional(string, "Standard")<br>    account_replication_type          = optional(string, "ZRS")<br>    access_tier                       = optional(string, "Cool")<br>    log_retention_days                = optional(number, null)<br>    move_to_cold_after_days           = optional(number, null)<br>    move_to_archive_after_days        = optional(number, null)<br>    snapshot_retention_days           = optional(number, 90)<br>    infrastructure_encryption_enabled = optional(bool, true)<br>    cmk_key_vault_id                  = optional(string, null)<br>    cmk_key_name                      = optional(string, null)<br>    system_assigned_identity_enabled  = optional(bool, false)<br>    user_assigned_identities          = optional(list(string), [])<br>    enable_law_data_export            = optional(bool, false)<br>    immutability_policy = optional(object({<br>      state                         = optional(string, "Unlocked")<br>      allow_protected_append_writes = optional(bool, true)<br>      period_since_creation_in_days = optional(number, 14)<br>    }, null))<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | n/a |
<!-- END_TF_DOCS -->