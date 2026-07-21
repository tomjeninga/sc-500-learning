// SC-500 Lab - RBAC role assignment on a resource group
// Mirrors: 01-identity-governance/templates/rbac-assignments.json
// Deploy at resource group scope:
//   az deployment group create --resource-group rg-sc500-lab --template-file infra/modules/rbac-assignments.bicep

@description('The object ID of the user, group, or service principal to assign the role to.')
param principalId string

@description('The type of principal being assigned.')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
])
param principalType string = 'Group'

@description('The built-in role to assign.')
@allowed([
  'Owner'
  'Contributor'
  'Reader'
  'Security Reader'
  'Security Admin'
  'User Access Administrator'
])
param roleDefinitionName string = 'Security Reader'

var builtInRoleIds = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Security Reader': '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  'Security Admin': 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
}

var roleDefinitionId = builtInRoleIds[roleDefinitionName]

resource ra 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}

output roleAssignmentId string = ra.id
output assignedRole string = roleDefinitionName
output assignedScope string = resourceGroup().id
