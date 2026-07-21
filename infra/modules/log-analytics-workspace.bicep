// SC-500 Lab - Log Analytics workspace with daily cap
// Mirrors: 03-security-operations/templates/log-analytics-workspace.json

@description('Name of the Log Analytics workspace.')
param workspaceName string = 'law-sc500-sentinel'

@description('Azure region for the workspace.')
param location string = resourceGroup().location

@description('Pricing tier. PerGB2018 is recommended for most lab scenarios.')
@allowed([
  'Free'
  'PerGB2018'
  'CapacityReservation'
])
param sku string = 'PerGB2018'

@description('Number of days to retain data. 30 days minimizes costs for lab.')
@minValue(7)
@maxValue(730)
param retentionInDays int = 30

@description('Daily ingestion cap in GB. Prevents unexpected cost overruns.')
param dailyQuotaGb int = 1

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: {
    Purpose: 'SC-500 Learning Lab'
    Domain: '03-Security-Operations'
  }
  properties: {
    sku: { name: sku }
    retentionInDays: retentionInDays
    workspaceCapping: { dailyQuotaGb: dailyQuotaGb }
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output workspaceId string = workspace.id
output workspaceName string = workspace.name
output workspaceResourceId string = workspace.id
output customerId string = workspace.properties.customerId
