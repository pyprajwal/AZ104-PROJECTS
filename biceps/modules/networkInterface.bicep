@description('The location where resources are deployed.')
param location string

@description('The name of the network interface to deploy.')
param networkInterfaceName string

@description('The ID of the public IP address to associate with the network interface.')
param publicIPAddressId string

@description('The ID of the default subnet in the virtual network.')
param defaultSubnetId string

@description('The ID of the network security group to associate with the network interface.')
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
      id: networkSecurityGroupId
    }
    nicType: 'Standard'
  }
}

output networkInterfaceId string = networkInterface.id
