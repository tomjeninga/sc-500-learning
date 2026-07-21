// SC-500 Lab - Orchestrator (resource group scope) chaining the most common lab modules
// Deploys VNet + Log Analytics + Sentinel. Storage/SQL/App Gateway modules are called individually.

targetScope = 'resourceGroup'

param location string = resourceGroup().location

module vnet 'modules/vnet-with-nsg.bicep' = {
  name: 'deploy-vnet'
  params: {
    location: location
  }
}

module law 'modules/log-analytics-workspace.bicep' = {
  name: 'deploy-log-analytics'
  params: {
    location: location
  }
}

module sentinel 'modules/sentinel-workspace.bicep' = {
  name: 'deploy-sentinel'
  params: {
    location: location
    workspaceName: law.outputs.workspaceName
  }
  dependsOn: [ law ]
}

output vnetId string = vnet.outputs.vnetId
output workspaceId string = law.outputs.workspaceId
output sentinelSolutionId string = sentinel.outputs.sentinelSolutionId
