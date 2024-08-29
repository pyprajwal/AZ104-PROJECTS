# Azure Virtual Machine Deployment with Bicep

This project contains Bicep templates for deploying an multiple Azure Virtual Machine (VM) with associated networking resources, including Virtual Network (VNet), Subnet, Network Security Group (NSG), Network Interface (NIC), and Public IP Address. The templates are designed to be flexible and reusable, allowing for easy customization of resources.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Deploying the Template](#deploying-the-template)
- [Parameters](#parameters)
- [Modules](#modules)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
![image](https://github.com/user-attachments/assets/401f9315-a0f0-44b7-b7b6-e5c914fa3772)

This project provides an Azure Bicep template that allows you to deploy a Virtual Machine along with all the necessary networking components in a single deployment. The template includes:

- A Virtual Network (VNet) with a default subnet.
- A Network Security Group (NSG) with default security rules.
- A Public IP Address.
- A Network Interface (NIC) associated with the Public IP Address.
- A Virtual Machine (VM) with customizable settings.

## Prerequisites

Before you begin, ensure you have the following:

- An active Azure subscription.
- Azure CLI installed on your local machine.
- Access to a resource group where the resources will be deployed.

## Getting Started

### Clone the Repository

bash

Copy code

`git clone https://github.com/pyprajwal/AZ104-PROJECTS.git`

`cd bicep`

### Deploying the Template

1.  Open a terminal and navigate to the directory containing the Bicep files.

2.  Use the Azure CLI to deploy the Bicep template.

bash

Copy code

`az deployment group create --resource-group <YourResourceGroup> --template-file main.bicep --parameters main.parameters.dev.json`

Replace `<YourResourceGroup>` with the name of your Azure resource group and `parameters.json` with your parameter file if you're using one.

## Parameters

The template supports the following parameters:

- **`location`**: The Azure region where the resources will be deployed.
- **`virtualMachineSizeName`**: The size of the virtual machine (e.g., `Standard_B2s`).
- **`virtualMachineManagedDiskStorageAccountType`**: The storage account type for the managed disk (e.g., `Standard_LRS`).
- **`virtualMachineAdminUsername`**: The administrator username for the VM.
- **`virtualMachineAdminPassword`**: The administrator password for the VM.
- **`publicIPAddressSkuName`**: The SKU of the Public IP address (`Standard` or `Basic`).
- **`virtualNetworkAddressPrefix`**: The address prefix for the Virtual Network (e.g., `10.0.0.0/16`).
- **`virtualNetworkDefaultSubnetAddressPrefix`**: The address prefix for the default subnet (e.g., `10.0.1.0/24`).
- **`env`**: The environment for the deployment (`dev`, `prod`, `test`).
- **`resourceSuffix`**: A unique suffix for resource names.
- **`numberOfVMs`**: The number of virtual machines to deploy.
- **`virtualMachineImageReference`**: The reference to the VM image (e.g., `publisher`, `offer`, `sku`, `version`).

## Modules

The Bicep template is divided into several modules:

- **`networkSecurityGroup.bicep`**: Deploys the Network Security Group (NSG).
- **`publicIPAddress.bicep`**: Deploys the Public IP Address.
- **`virtualNetwork.bicep`**: Deploys the Virtual Network (VNet) and subnet.
- **`networkInterface.bicep`**: Deploys the Network Interface (NIC).
- **`virtualMachine.bicep`**: Deploys the Virtual Machine (VM).

## Outputs

The template provides the following outputs:

- **`virtualMachineId`**: The resource ID of the deployed virtual machine.
- **`networkInterfaceId`**: The resource ID of the deployed network interface.
- **`publicIPAddressId`**: The resource ID of the deployed public IP address.

## Contributing

Contributions are welcome! If you find a bug or want to add a new feature, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
