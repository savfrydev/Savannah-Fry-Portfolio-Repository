resource "azurerm_resource_group" "rg" {
  name     = "portfolio-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "sa" {
  name                     = "portfoliosa0011"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
  
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}


