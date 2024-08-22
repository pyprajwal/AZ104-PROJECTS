param location string

param networkInterfaceName string

param publicIPAddressId string

param defaultSubnetId string

param networkSecurityGroupId string

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressId
            properties: {
              deleteOption: 'Detach'
            }
            sku: {
              name: 'Basic'
              tier: 'Regional'
            }
          }
          subnet: {
            id: defaultSubnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      // id: networkSecurityGroupModule.outputs.networkSecurityGroupId
      id: networkSecurityGroupId
    }
    nicType: 'Standard'
  }
}
output networkInterfaceID string = networkInterface.id
