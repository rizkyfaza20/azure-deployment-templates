provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.62.1"
    }
  }
}
resource "azurerm_resource_group" "aks_rg" {
  name     = var.aks_cluster_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  kubernetes_version = var.kubernetes_version
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name            = "system"
    vm_size         = "Standard_DS2_v2"
    type = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count       = 1
    max_count       = 3
  }

  tags = {
    environment = "dev"
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    load_balancer_sku = "standard"
    network_plugin = "kubenet"
  }
}