// SC-500 Lab - Application Gateway v2 with WAF_v2 policy
// Mirrors: 02-platform-protection/templates/app-gateway-waf.json

@description('Name of the Application Gateway.')
param appGatewayName string = 'agw-sc500-waf'

@description('Name of the VNet where App Gateway will be deployed.')
param vnetName string = 'vnet-sc500-lab'

@description('Subnet for the Application Gateway (must be dedicated).')
param subnetName string = 'snet-frontend'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Name for the WAF policy resource.')
param wafPolicyName string = 'waf-policy-sc500'

@description('WAF mode. Use Detection first, then switch to Prevention.')
@allowed([
  'Detection'
  'Prevention'
])
param wafMode string = 'Prevention'

var publicIpName = 'pip-agw-sc500'
var appGwSubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource pip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIpName
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wafPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2023-04-01' = {
  name: wafPolicyName
  location: location
  properties: {
    policySettings: {
      state: 'Enabled'
      mode: wafMode
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
        }
      ]
      exclusions: []
    }
    customRules: [
      {
        name: 'BlockHighRequestRate'
        priority: 10
        ruleType: 'RateLimitRule'
        action: 'Block'
        rateLimitDuration: 'OneMin'
        rateLimitThreshold: 100
        matchConditions: [
          {
            matchVariables: [
              { variableName: 'RequestUri' }
            ]
            operator: 'Contains'
            negationCondition: false
            matchValues: [ '/' ]
          }
        ]
      }
    ]
  }
}

resource appGw 'Microsoft.Network/applicationGateways@2023-04-01' = {
  name: appGatewayName
  location: location
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 2
    }
    firewallPolicy: { id: wafPolicy.id }
    gatewayIPConfigurations: [
      {
        name: 'appGwIpConfig'
        properties: { subnet: { id: appGwSubnetId } }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontend'
        properties: { publicIPAddress: { id: pip.id } }
      }
    ]
    frontendPorts: [
      {
        name: 'port-80'
        properties: { port: 80 }
      }
    ]
    backendAddressPools: [
      {
        name: 'backend-pool-01'
        properties: { backendAddresses: [] }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'settings-http'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 30
        }
      }
    ]
    httpListeners: [
      {
        name: 'listener-http'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, 'appGwPublicFrontend')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, 'port-80')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'rule-http-to-backend'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, 'listener-http')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, 'backend-pool-01')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, 'settings-http')
          }
        }
      }
    ]
  }
}

output appGatewayId string = appGw.id
output appGatewayPublicIP string = pip.properties.ipAddress
output wafPolicyId string = wafPolicy.id
