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

var virtualNetworkName = '${resourceSuffix}-${env}-vnet'
var virtualMachineName = '${resourceSuffix}-${env}-VM'
var networkInterfaceName = '${resourceSuffix}-${env}-INTF'
var publicIPAddressName = '${resourceSuffix}-${env}-pubIP'
var networkSecurityGroupName = '${resourceSuffix}-${env}-NSG'
var virtualMachineOSDiskName = '${resourceSuffix}-${env}-DISK'

param virtualMachineImageReference object

module networkSecurityGroupModule 'modules/networkSecurityGroup.bicep' = {
  name: 'networkSecurityGroupDeployment'
  params: {
    location: location
    networkSecurityGroupName: networkSecurityGroupName
  }
}

module publicIPAddressModule 'modules/publicIPAddress.bicep' = {
  name: 'publicIPAddressDeployment'
  params: {
    location: location
    publicIPAddressName: publicIPAddressName
    publicIPAddressSkuName: publicIPAddressSkuName
  }
}

module virtualNetworkModule 'modules/virtualNetwork.bicep' = {
  name: 'virtualNetworkDeployment'
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    virtualNetworkDefaultSubnetAddressPrefix: virtualNetworkDefaultSubnetAddressPrefix
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSizeName
    }
    storageProfile: {
      imageReference: virtualMachineImageReference
      osDisk: {
        osType: 'Linux'
        name: virtualMachineOSDiskName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: virtualMachineManagedDiskStorageAccountType
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: virtualMachineAdminUsername
      adminPassword: virtualMachineAdminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceModule.outputs.networkInterfaceID
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

module networkInterfaceModule 'modules/networkInterface.bicep' = {
  name: 'networkInterfaceDeployment'
  params: {
    defaultSubnetId: virtualNetworkModule.outputs.defaultSubnetId
    networkSecurityGroupId: networkSecurityGroupModule.outputs.networkSecurityGroupId
    publicIPAddressId: publicIPAddressModule.outputs.publicIPAddressId
    networkInterfaceName: networkInterfaceName
    location: location
  }
}
