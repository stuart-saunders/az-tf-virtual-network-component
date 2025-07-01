resource_group_name = "rg-component-examples"

vnets = [
  {
    name          = "vnet-cmp-ex-01"
    address_space = ["10.0.0.0/24"]

    peerings = [
      {
        provider = "azapi"

        remote_virtual_network = {
          name = "vnet-cmp-ex-02"
        }

        source_to_remote_config = {
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
        }

        remote_to_source_config = {
          allow_virtual_network_access = true
        }
      }
    ]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.0.0/26"]

        nsg = {
          name = "nsg-snwt01-vnet01"
          rules = [
            {
              name                   = "HTTPS"
              priority               = "500"
              direction              = "Inbound"
              access                 = "Allow"
              protocol               = "Tcp"
              source_address_prefix  = "*"
              source_port_range      = "*"
              destination_port_range = "443"
            },
          ]
        },
      },
    ]

    tags = {
      ResourceType = "virtualNetworks"
    }
  },
  {
    name          = "vnet-cmp-ex-02"
    address_space = ["10.0.1.0/24"]

    subnets = [
      {
        provider         = "azapi"
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/26"]

        nsg = {
          name = "nsg-snet01-vnet02"

          rules = [
            {
              name                   = "HTTPS"
              priority               = "500"
              direction              = "Inbound"
              access                 = "Allow"
              protocol               = "Tcp"
              source_address_prefix  = "*"
              source_port_range      = "*"
              destination_port_range = "443"
            },
          ]
        }
      }
    ]

    tags = {
      ResourceType = "virtualNetworks"
    }
  },
]

tags = {
  Environment = "Dev"
}
