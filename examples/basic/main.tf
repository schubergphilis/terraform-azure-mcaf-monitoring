terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

provider "azurerm" {
  subscription_id = "2ba489e8-3466-4f52-a32d-263d28b832e1"
  features {}
}

module "without_storage_account" {
  source = "../.."

  resource_group = {
    name = "example-resource-group"
  }

  log_analytics_workspace = {
    name = "example-log-analytics-workspace"
  }

  location = "West Europe"
  tags     = {}
}

module "with_storage_account" {
  source = "../.."

  resource_group = {
    name = "example-resource-group2"
  }

  log_analytics_workspace = {
    name = "example-log-analytics-workspace2"
  }

  storage_account = {
    name                     = "examplestorageaccount"
    access_tier              = "Cool"
    account_replication_type = "ZRS"
    log_retention_days       = 1095 # 3 Years
    snapshot_retention_days  = 90
  }

  location = "West Europe"
  tags     = {}
}