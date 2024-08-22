@description('The location where resources are deployed.')
param location string

@description('The name of the public IP address.')
param publicIPAddressName string

@description('The name of the SKU of the public IP address to deploy.')
param publicIPAddressSkuName string

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: publicIPAddressSkuName
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

output publicIPAddressId string = publicIPAddress.id
