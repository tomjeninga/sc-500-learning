// SC-500 Lab - Enable Microsoft Sentinel on an existing Log Analytics workspace
// Mirrors: 03-security-operations/templates/sentinel-workspace.json

@description('Name of the existing Log Analytics workspace to enable Sentinel on.')
param workspaceName string = 'law-sc500-sentinel'

@description('Azure region - must match the workspace region.')
param location string = resourceGroup().location

var solutionName = 'SecurityInsights(${workspaceName})'

resource sentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutionName
  location: location
  properties: {
    workspaceResourceId: resourceId('Microsoft.OperationalInsights/workspaces', workspaceName)
  }
  plan: {
    name: solutionName
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
}

output sentinelSolutionId string = sentinelSolution.id
output sentinelWorkspaceName string = workspaceName
