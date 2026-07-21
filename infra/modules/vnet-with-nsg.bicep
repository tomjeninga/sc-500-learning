// SC-500 Lab - VNet with tiered NSGs and AzureBastionSubnet
// Mirrors: 02-platform-protection/templates/vnet-with-nsg.json

@description('Name of the Virtual Network.')
param vnetName string = 'vnet-sc500-lab'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Address space for the VNet.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Address prefix for the frontend subnet.')
param frontendSubnetPrefix string = '10.0.1.0/24'

@description('Address prefix for the backend subnet.')
param backendSubnetPrefix string = '10.0.2.0/24'

@description('Address prefix for the data tier subnet.')
param dataSubnetPrefix string = '10.0.3.0/24'

@description('Address prefix for AzureBastionSubnet (minimum /27, recommended /26).')
param bastionSubnetPrefix string = '10.0.4.0/26'

var nsgFrontendName = 'nsg-frontend'
var nsgBackendName = 'nsg-backend'
var nsgDataName = 'nsg-data'

resource nsgFrontend 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: nsgFrontendName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'Allow-HTTP-Inbound'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          priority: 4000
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource nsgBackend 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: nsgBackendName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Frontend-8080'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: frontendSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          priority: 4000
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource nsgData 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: nsgDataName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Backend-SQL'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: backendSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '1433'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          priority: 4000
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ vnetAddressPrefix ]
    }
    subnets: [
      {
        name: 'snet-frontend'
        properties: {
          addressPrefix: frontendSubnetPrefix
          networkSecurityGroup: { id: nsgFrontend.id }
        }
      }
      {
        name: 'snet-backend'
        properties: {
          addressPrefix: backendSubnetPrefix
          networkSecurityGroup: { id: nsgBackend.id }
        }
      }
      {
        name: 'snet-data'
        properties: {
          addressPrefix: dataSubnetPrefix
          networkSecurityGroup: { id: nsgData.id }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output frontendSubnetId string = '${vnet.id}/subnets/snet-frontend'
output backendSubnetId string = '${vnet.id}/subnets/snet-backend'
output nsgFrontendId string = nsgFrontend.id
