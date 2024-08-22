@description('The location where resources are deployed.')
param location string = resourceGroup().location

@description('The name of the virtual network.')
param virtualNetworkName string

@description('The virtual network address range.')
param virtualNetworkAddressPrefix string = '10.0.0.0/16'

@description('The default subnet address range within the virtual network')
param virtualNetworkDefaultSubnetAddressPrefix string = '10.0.0.0/24'

var virtualNetworkDefaultSubnetName = 'default'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: virtualNetworkDefaultSubnetName
        properties: {
          addressPrefix: virtualNetworkDefaultSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }

  resource defaultSubnet 'subnets' existing = {
    name: virtualNetworkDefaultSubnetName
  }
}

output virtualNetworkId string = virtualNetwork.id
output defaultSubnetId string = virtualNetwork::defaultSubnet.id
