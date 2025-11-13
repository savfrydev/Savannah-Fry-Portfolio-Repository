########################################
# Resource Group
########################################
resource "azurerm_resource_group" "rg" {
  name     = "portfolio-rg"
  location = "eastus"
}

########################################
# Storage Account (Static Website Host)
########################################
resource "azurerm_storage_account" "sa" {
  name                     = "portfoliosa0011"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

########################################
# Azure Front Door Profile
########################################
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "fdp-portfolio-new"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"

  lifecycle {
    prevent_destroy = true
  }
}

########################################
# Azure Front Door Endpoint
########################################
resource "azurerm_cdn_frontdoor_endpoint" "fd" {
  name                     = "portfolio-endpoint-new"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

########################################
# Azure Front Door Origin Group
########################################
resource "azurerm_cdn_frontdoor_origin_group" "default" {
  name                     = "default-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 60
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 0
  }
}

########################################
# Azure Front Door Origin (Storage Static Website)
########################################
resource "azurerm_cdn_frontdoor_origin" "static" {
  name                          = "storage-web"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default.id

  host_name                     = azurerm_storage_account.sa.primary_web_host
  origin_host_header            = azurerm_storage_account.sa.primary_web_host

  certificate_name_check_enabled = false
  http_port                      = 80
  https_port                     = 443

  priority = 1
  weight   = 1
}

########################################
# Azure Front Door Route
########################################
resource "azurerm_cdn_frontdoor_route" "default" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default.id

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.static.id
  ]

  # Add custom domain here:
  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.portfolio_domain.id
  ]

  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true

  link_to_default_domain = false
}


########################################
# Azure Front Door Custom Domain
########################################
resource "azurerm_cdn_frontdoor_custom_domain" "portfolio_domain" {
  name                       = "savannahfry-dev-domain"
  cdn_frontdoor_profile_id   = azurerm_cdn_frontdoor_profile.fd.id
  host_name                  = "www.savannahfry.dev"

  tls {
    certificate_type               = "ManagedCertificate"
    minimum_tls_version            = "TLS12"
  }
}


