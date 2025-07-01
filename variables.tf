variable "subscription_id" {
  type        = string
  description = "The subscription that the configuration runs against"
}

variable "azapi_config" {
  type = object({
    use_msi = optional(bool, false)
  })
  description = <<-DESC
    Configuration settings for the AzApi provider.
    `use_msi`: Determines whether the AzApi provider should authenticate with user credentials or Managed Identity. Defaults to `false`.
  DESC
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The Resource Group in which the network reources should be deployed"
}

variable "location" {
  type        = string
  description = "The Azure Region in which to create the Resource Group"
  default     = "uksouth"
}

variable "vnets" {
  type = list(object({
    name          = string
    address_space = list(string)
    location      = optional(string, "uksouth")
    dns_servers   = optional(list(string), [])

    peerings = optional(list(object({
      provider = optional(string, "azurerm")
      name     = optional(string, null)

      remote_virtual_network = object({
        id                  = optional(string, null)
        name                = optional(string, null)
        resource_group_name = optional(string, null)
        # subscription_shortname = optional(string, null)
      })

      source_to_remote_config = optional(object({
        allow_forwarded_traffic      = optional(bool, false)
        allow_gateway_transit        = optional(bool, false)
        allow_virtual_network_access = optional(bool, false)
        use_remote_gateways          = optional(bool, false)
        triggers                     = optional(map(string), null)
      }), {})

      remote_to_source_config = optional(object({
        allow_forwarded_traffic      = optional(bool, false)
        allow_gateway_transit        = optional(bool, false)
        allow_virtual_network_access = optional(bool, false)
        use_remote_gateways          = optional(bool, false)
        triggers                     = optional(map(string), null)
      }), {})
    })), [])

    subnets = optional(list(object({
      provider          = optional(string, "azurerm")
      name              = optional(string, null)
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), null)

      nsg = optional(object({
        name        = optional(string, null)
        name_suffix = optional(string, null)

        rules = optional(list(object({
          name                         = string
          priority                     = string
          direction                    = string
          access                       = string
          protocol                     = string
          source_address_prefix        = optional(string, null)
          source_address_prefixes      = optional(list(string), null)
          source_port_range            = optional(string, null)
          source_port_ranges           = optional(list(string), null)
          destination_address_prefix   = optional(string, null)
          destination_address_prefixes = optional(list(string), null)
          destination_port_range       = optional(string, null)
          destination_port_ranges      = optional(list(string), null)
        })), [])
      }), null)

      nsg_id = optional(string, null)

      route_table = optional(object({
        name                          = string
        disable_bgp_route_propagation = optional(bool, null)

        routes = optional(list(object({
          name                   = string
          address_prefix         = string
          next_hop_type          = string
          next_hop_in_ip_address = optional(string, null)
        })), [])
      }), null)

      route_table_id = optional(string, null)
    })), [])

    tags = optional(map(string), {})
  }))
  description = "List of Virtual Networks, Peerings, Subnets, NSGs and Rules to create"
}

variable "common_nsg_rules" {
  type = list(object({
    name                         = string
    priority                     = string
    direction                    = string
    access                       = string
    protocol                     = string
    source_address_prefix        = optional(string, null)
    source_address_prefixes      = optional(list(string), null)
    source_port_range            = optional(string, null)
    source_port_ranges           = optional(list(string), null)
    destination_address_prefix   = optional(string, null)
    destination_address_prefixes = optional(list(string), null)
    destination_port_range       = optional(string, null)
    destination_port_ranges      = optional(list(string), null)
  }))
  description = "A list of common NSG rules that should apply to all of the NSGs in the configuration"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply all resources"
  default     = {}
}
