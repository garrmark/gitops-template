terraform {
  backend "azurerm" {
    resource_group_name  = "<CLUSTER_NAME>"
    storage_account_name = "<KUBEFIRST_STATE_STORE_BUCKET>"
    container_name       = "<KUBEFIRST_STATE_STORE_BUCKET>"
    key                  = "terraform/azure/terraform.tfstate"
    use_msi              = true
    client_id            = var.client_id
    subscription_id      = var.subscription_id
    tenant_id            = var.tenant_id
    client_secret        = var.client_secret
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
  }

}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.4.1"
}

resource "azurerm_resource_group" "rg" {
  location = var.azure_region
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_user_assigned_identity" "user_identity" {
  location            = azurerm_resource_group.rg.location
  name                = var.kubernetes_cluster_name
  resource_group_name = "<CLUSTER_NAME>"
}

module "aks" {
  source              = "Azure/avm-ptn-aks-production/azurerm"
  kubernetes_version  = var.kubernetes_version
  enable_telemetry    = var.enable_telemetry
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = "<CLUSTER_NAME>"
  managed_identities = {
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.user_identity.id
    ]
  }

  location = azurerm_resource_group.rg.location
  node_pools = {
    workload = {
      name                 = var.system_node_pool_name
      vm_size              = var.vm_size
      orchestrator_version = var.kubernetes_version
      max_count            = 3
      min_count            = 1
      os_sku               = var.os_sku
      mode                 = var.mode
    }
  }
}
