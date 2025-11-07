resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.50.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.prefix}-aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.50.1.0/24"]
}

resource "azurerm_container_registry" "acr" {
  name                = replace("${var.prefix}acr", "-", "")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-dns"

  kubernetes_version = var.kubernetes_version
  private_cluster_enabled = var.enable_private_cluster

  default_node_pool {
    name       = "sys"
    vm_size    = var.node_size
    node_count = var.node_count
    vnet_subnet_id = azurerm_subnet.aks.id
    only_critical_addons_enabled = true
    upgrade_settings { max_surge = "33%" }
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin     = "azure"
    network_plugin_mode= "overlay"
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_policy     = "calico"
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  api_server_access_profile { authorized_ip_ranges = var.authorized_ip_ranges }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  tags = { env = "prod-like" }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "resource_group" { value = azurerm_resource_group.rg.name }
output "aks_name"       { value = azurerm_kubernetes_cluster.aks.name }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }
output "kube_config" { value = azurerm_kubernetes_cluster.aks.kube_config_raw sensitive = true }
