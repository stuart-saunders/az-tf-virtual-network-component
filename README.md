# Azure Virtual Network Component

Terraform Component for provisioning Virtual Networks on Azure.

## Description

The component enables the creation of Virtual Networks, in addition to their dependent, child resources. Each Virtual Network can contain multiple peerings and subnets, each of which can contain a Network Security Group, itself containing multiple Network Security Rules. Each Subnet can also contain a Route Table, which itself can contain multiple routes. All of these can be defined within a single object, which the module will use this to provision the resources required.

The required resources should be defined in a list of one of more Virtual Network objects, with each containing lists of the required child resources as object properties.

The component should be called with a `.tfvars` file containing the values defining the infrastructure required, and the component will call the required module(s) to perform the provisioning.

## Modules

The component calls the following modules to provision resources:-

- `az-tf-virtual-network-module`

## Inputs
The component supports the inputs:-

- `subscription_id`: The Id of the subscription in which the resources should be created. All resources must be in the same subscription.
- `location`: The location in which the resources should be created. Defaults to `uksouth`
- `resource_group_name`: The name of the Resource Group in which the resources should be created
- `vnets`: A list of one or more Virtual Networks to create
  - `name` The Virtual Network name
  - `address_space`: The Virtual Network's address space
  - `dns_servers`: A list of the IP Addresses of the Virtual Network's DNS Servers
  - `peerings`: An optional list of Virtual Networks that the Virtual Network should be peered with. Peerings will be created in both directions.
    - `provider`: The provider that should be used to create the peerings. Defaults to `azurerm`, and `azapi` also supported.
    - `name`: The peering name
    - `remote_virtual_network`: The details of the Virtual Network to peer to. Either the `id`, or the `name` and `resource_group_name` should be provided to identify the network.
      - `id`: The Virtual Network's Id
      - `name`: The Virtual Network name
      - `resource_group_name`: The Virtual Network's Resource Group
    - `source_to_remote_config`: The peering configuration for the outbound peering
    - `remote_to_source_config`: The peering configuration for the inbound peering
  - `subnets`: An optional list of subnets to create
     - `provider`: The provider that should be used to create the peerings. Defaults to `azurerm`, and `azapi` also supported.
    - `name`: The subnet name
    - `address_prefixes`: A list of the subnet's address prefixes.
    - `service_endpoints`: An optional list of Service Endpoints that the subnet should support
    - `nsg`: The details of an optional NSG, with optional list of Rules, to create and associate with the subnet
    - `nsg_id`: The optional Id of an existing NSG to associate with the subnet
    - `route-table`: The details of an optional Route Table, with optional list of Routes, to create and associate with the subnet
    - `route_table_id`: The optional Id of an existing Route Table to associate with the subnet
- `common_nsg_rules`: An optional list of NSG Rules to apply across all NSGs in the configuration

## Outputs

N/A