output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "static_website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "frontdoor_endpoint" {
  value = azurerm_cdn_frontdoor_endpoint.fd.host_name
}

