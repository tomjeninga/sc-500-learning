// SC-500 Lab - Azure SQL server + database with Entra-only auth, TDE, ATP, and auditing
// Mirrors: 04-data-protection/templates/sql-database-secured.json

@description('Globally unique SQL server name (lowercase, 1-63 chars).')
param sqlServerName string

@description('Name of the SQL database.')
param databaseName string = 'sqldb-sc500-lab'

@description('Azure region for the SQL resources.')
param location string = resourceGroup().location

@description('Object ID of the Entra ID user or group to set as SQL Administrator.')
param sqlAdminObjectId string

@description('Display name/login of the Entra ID SQL Administrator.')
param sqlAdminLogin string

@description('Client IP to allow through SQL firewall. Set to 0.0.0.0 to allow Azure services only.')
param allowedClientIp string = '0.0.0.0'

@description('Resource ID of Log Analytics workspace for audit logs. Leave empty to skip.')
param auditLogWorkspaceId string = ''

resource sqlServer 'Microsoft.Sql/servers@2023-02-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    Purpose: 'SC-500 Learning Lab'
    Domain: '04-Data-Protection'
  }
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: sqlAdminLogin
      sid: sqlAdminObjectId
      tenantId: subscription().tenantId
      azureADOnlyAuthentication: true
    }
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

resource fwAllowAzure 'Microsoft.Sql/servers/firewallRules@2023-02-01-preview' = {
  parent: sqlServer
  name: 'AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource fwAllowClient 'Microsoft.Sql/servers/firewallRules@2023-02-01-preview' = if (allowedClientIp != '0.0.0.0') {
  parent: sqlServer
  name: 'AllowClientIP'
  properties: {
    startIpAddress: allowedClientIp
    endIpAddress: allowedClientIp
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2023-02-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: {
    name: 'GP_S_Gen5_1'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    autoPauseDelay: 60
    minCapacity: json('0.5')
    readScale: 'Disabled'
  }
}

resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2023-02-01-preview' = {
  parent: sqlDb
  name: 'current'
  properties: { state: 'Enabled' }
}

resource atp 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2023-02-01-preview' = {
  parent: sqlServer
  name: 'Default'
  properties: { state: 'Enabled' }
}

resource auditing 'Microsoft.Sql/servers/auditingSettings@2023-02-01-preview' = {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: !empty(auditLogWorkspaceId)
    isDevopsAuditEnabled: false
    retentionDays: 90
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
  }
}

output sqlServerId string = sqlServer.id
output sqlServerFQDN string = sqlServer.properties.fullyQualifiedDomainName
output databaseId string = sqlDb.id
output connectionString string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Database=${databaseName};Authentication=Active Directory Default;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
