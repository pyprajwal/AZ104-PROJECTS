@description('The location where resources are deployed.')
param location string = resourceGroup().location

@description('The name of the size of the virtual machine to deploy.')
param virtualMachineSizeName string

@description('The name of the storage account SKU to use for the virtual machine\'s managed disk.')
param virtualMachineManagedDiskStorageAccountType string

@description('The administrator username for the virtual machine.')
param virtualMachineAdminUsername string

@description('The administrator password for the virtual machine.')
@secure()
param virtualMachineAdminPassword string

@description('The name of the SKU of the public IP address to deploy.')
param publicIPAddressSkuName string = 'Standard'

@description('The virtual network address range.')
param virtualNetworkAddressPrefix string

@description('The default subnet address range within the virtual network')
param virtualNetworkDefaultSubnetAddressPrefix string

@allowed([
  'dev'
  'prod'
  'test'
])
param env string

@description('The deployment-specific suffix to make resource names unique.')
param resourceSuffix string = uniqueString(resourceGroup().id, deployment().name)

@description('The number of virtual machines to deploy.')
param numberOfVMs int = 2

param virtualMachineImageReference object

var virtualNetworkNamePrefix = '${resourceSuffix}-${env}-vnet'
var networkInterfaceNamePrefix = '${resourceSuffix}-${env}-nic'
var publicIPAddressNamePrefix = '${resourceSuffix}-${env}-pubIP'
var networkSecurityGroupName = '${resourceSuffix}-${env}-nsg'
var virtualMachineNamePrefix = '${resourceSuffix}-${env}-vm'
var virtualMachineOSDiskName = '${resourceSuffix}-${env}-osdisk'
var publicIPAddressNames = [for i in range(0, numberOfVMs): '${publicIPAddressNamePrefix}-${i}']
var networkInterfaceNames = [for i in range(0, numberOfVMs): '${networkInterfaceNamePrefix}-${i}']
var virtualNetworkName = [for i in range(0, numberOfVMs): '${virtualNetworkNamePrefix}-${i}']

module networkSecurityGroupModule 'modules/networkSecurityGroup.bicep' = {
  name: 'networkSecurityGroupDeployment'
  params: {
    location: location
    networkSecurityGroupName: networkSecurityGroupName
  }
}

module virtualNetworkModule 'modules/virtualNetwork.bicep' = [
  for i in range(0, numberOfVMs): {
    name: 'virtualNetworkDeployment-${i}'
    params: {
      location: location
      virtualNetworkName: virtualNetworkName[i]
      virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
      virtualNetworkDefaultSubnetAddressPrefix: virtualNetworkDefaultSubnetAddressPrefix
    }
  }
]

module publicIPAddressModule 'modules/publicIPAddress.bicep' = [
  for i in range(0, numberOfVMs): {
    name: 'publicIPAddressDeployment-${i}'
    params: {
      location: location
      publicIPAddressName: publicIPAddressNames[i]
      publicIPAddressSkuName: publicIPAddressSkuName
    }
  }
]

module networkInterfaceModule 'modules/networkInterface.bicep' = [
  for i in range(0, numberOfVMs): {
    name: 'networkInterfaceDeployment-${i}'
    params: {
      location: location
      networkInterfaceName: networkInterfaceNames[i]
      publicIPAddressId: publicIPAddressModule[i].outputs.publicIPAddressId
      defaultSubnetId: virtualNetworkModule[i].outputs.defaultSubnetId
      networkSecurityGroupId: networkSecurityGroupModule.outputs.networkSecurityGroupId
    }
  }
]

module virtualMachineModule 'modules/virtualMachine.bicep' = [
  for i in range(0, numberOfVMs): {
    name: 'virtualMachineDeployment-${i}'
    params: {
      location: location
      virtualMachineSizeName: virtualMachineSizeName
      virtualMachineManagedDiskStorageAccountType: virtualMachineManagedDiskStorageAccountType
      virtualMachineAdminUsername: virtualMachineAdminUsername
      virtualMachineAdminPassword: virtualMachineAdminPassword
      virtualMachineName: '${virtualMachineNamePrefix}-${i}'
      virtualMachineOSDiskName: '${virtualMachineOSDiskName}-${i}'
      virtualMachineImageReference: virtualMachineImageReference
      networkInterfaceId: networkInterfaceModule[i].outputs.networkInterfaceId
      networkInterfaceName: networkInterfaceNames[i]
    }
  }
]
