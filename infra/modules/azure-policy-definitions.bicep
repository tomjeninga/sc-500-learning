// SC-500 Lab - Custom Azure Policy definitions and assignment
// Mirrors: 05-governance-compliance/templates/azure-policy-definitions.json
// Deploy at subscription scope:
//   az deployment sub create --location <region> --template-file infra/modules/azure-policy-definitions.bicep

targetScope = 'subscription'

@description('Effect for the CostCenter tag policy. Use Audit to test first, then switch to Deny.')
@allowed([
  'Deny'
  'Audit'
  'Disabled'
])
param policyEffect string = 'Audit'

@description('The tag name that must be present on all resources.')
param requiredTagName string = 'CostCenter'

@description('Scope to assign the policy to. Defaults to rg-sc500-lab in the current subscription.')
param policyAssignmentScope string = '${subscription().id}/resourceGroups/rg-sc500-lab'

var costCenterPolicyName = 'require-costcenter-tag-sc500'
var envPolicyName = 'require-environment-tag-sc500'
var policyAssignmentName = 'assign-costcenter-tag-sc500'

resource costCenterPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: costCenterPolicyName
  properties: {
    displayName: 'Require CostCenter tag on resources'
    description: 'Enforces the presence of a CostCenter tag on all resources (excluding resource groups and deployments).'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'SC500-Lab'
      version: '1.0.0'
    }
    parameters: {
      effect: {
        type: 'String'
        defaultValue: policyEffect
        allowedValues: [ 'Deny', 'Audit', 'Disabled' ]
        metadata: {
          displayName: 'Effect'
          description: 'Deny blocks non-compliant resources; Audit only logs them.'
        }
      }
      tagName: {
        type: 'String'
        defaultValue: requiredTagName
        metadata: {
          displayName: 'Required tag name'
          description: 'The name of the tag that must exist on all resources.'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            notIn: [
              'Microsoft.Resources/resourceGroups'
              'Microsoft.Resources/deployments'
              'Microsoft.Authorization/policyAssignments'
              'Microsoft.Authorization/roleAssignments'
              'Microsoft.Network/privateDnsZones/virtualNetworkLinks'
            ]
          }
          {
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: false
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}

resource envPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: envPolicyName
  properties: {
    displayName: 'Require Environment tag on resources'
    description: 'Requires an Environment tag with specific allowed values.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'SC500-Lab'
      version: '1.0.0'
    }
    parameters: {
      allowedValues: {
        type: 'Array'
        defaultValue: [ 'Production', 'Staging', 'Dev', 'Lab', 'Test' ]
        metadata: {
          displayName: 'Allowed environment tag values'
          description: 'The list of allowed values for the Environment tag.'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            notIn: [
              'Microsoft.Resources/resourceGroups'
              'Microsoft.Resources/deployments'
            ]
          }
          {
            not: {
              field: 'tags[\'Environment\']'
              in: '[parameters(\'allowedValues\')]'
            }
          }
        ]
      }
      then: {
        effect: 'Audit'
      }
    }
  }
}

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignmentName
  properties: {
    displayName: 'Deny/Audit - Require CostCenter Tag (SC-500 Lab)'
    description: 'Enforces CostCenter tag requirement in the SC-500 lab resource group.'
    policyDefinitionId: costCenterPolicy.id
    scope: policyAssignmentScope
    enforcementMode: 'Default'
    nonComplianceMessages: [
      {
        message: 'Resource must have a CostCenter tag. Please add the CostCenter tag before creating resources.'
      }
    ]
    parameters: {
      effect: { value: policyEffect }
      tagName: { value: requiredTagName }
    }
  }
}

output costCenterPolicyId string = costCenterPolicy.id
output envPolicyId string = envPolicy.id
output policyAssignmentId string = assignment.id
output assignedEffect string = policyEffect
