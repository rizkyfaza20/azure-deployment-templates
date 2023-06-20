provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "my-aks-resource-group"
  location = "southeastasia"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"
  identity {
    type = "SystemAssigned"
  }
  linux_profile {
    admin_username = "aksuser"

    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  default_node_pool {
    name            = "default"
    vm_size         = "Standard_DS2_v2"
    # availability_zones = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count       = 1
    max_count       = 3
  }
  tags = {
    environment = "dev"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}