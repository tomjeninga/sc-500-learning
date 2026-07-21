// SC-500 Lab - Storage account with CMK encryption and Private Endpoint
// Mirrors: 04-data-protection/templates/storage-account-encrypted.json

@description('Globally unique name for the storage account (3-24 chars, lowercase alphanumeric).')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Name of the Key Vault containing the CMK.')
param keyVaultName string = 'kv-sc500-lab'

@description('Name of the key in Key Vault to use for encryption.')
param keyName string = 'storage-cmk-key'

@description('Azure region for the storage account.')
param location string = resourceGroup().location

@description('VNet for private endpoint.')
param vnetName string = 'vnet-sc500-lab'

@description('Subnet for private endpoint.')
param subnetName string = 'snet-data'

var managedIdentityName = 'mi-sc500-storage'
var privateEndpointName = 'pe-storage-sc500'
var privateDnsZoneName = 'privatelink.blob.core.windows.net'
var privateEndpointSubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mi.id}': {}
    }
  }
  properties: {
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
        keyvaulturi: 'https://${keyVaultName}.vault.azure.net/'
        keyname: keyName
      }
      identity: {
        userAssignedIdentity: mi.id
      }
      requireInfrastructureEncryption: false
      services: {
        blob: { enabled: true }
        file: { enabled: true }
        table: { enabled: true }
        queue: { enabled: true }
      }
    }
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

resource pe 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: { id: privateEndpointSubnetId }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: storage.id
          groupIds: [ 'blob' ]
        }
      }
    ]
  }
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource dnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dnsZone
  name: 'link-to-${vnetName}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
  }
}

output storageAccountId string = storage.id
output storageAccountName string = storage.name
output managedIdentityId string = mi.id
output managedIdentityClientId string = mi.properties.clientId
output privateEndpointId string = pe.id
