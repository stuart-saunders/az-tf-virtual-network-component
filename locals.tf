locals {

  resource_group_name = var.resource_group_name

  vnets = { for vnet in var.vnets :
    "${vnet.name != null ? vnet.name : vnet.name_suffix}" => {
      name          = vnet.name
      address_space = vnet.address_space
      dns_servers   = vnet.dns_servers
      location      = vnet.location

      peerings = vnet.peerings

      subnets = [for subnet in vnet.subnets :
        {
          provider          = subnet.provider
          name              = subnet.name
          address_prefixes  = subnet.address_prefixes
          service_endpoints = subnet.service_endpoints

          # If an NSG has been defined within the subnet, redefine this to concatenate the common rules with the NSG's own rules - otherwise, set to null
          nsg = (
            (try(subnet.nsg, null) != null) ?
            {
              name  = subnet.nsg.name,
              rules = concat(var.common_nsg_rules, subnet.nsg.rules)
            } :
            null
          )
          nsg_id = try(subnet.nsg_id, null)

          route_table    = try(subnet.route_table, null)
          route_table_id = try(subnet.route_table_id, null)
        }
      ]

      tags = vnet.tags
    }
  }
}
