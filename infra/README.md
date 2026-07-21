# SC-500 Bicep Infrastructure

Bicep versions of the ARM templates in each domain's `templates/` folder. These are the primary IaC assets going forward - ARM templates remain as reference.

## Modules

| File | Purpose | Related ARM |
| --- | --- | --- |
| `main.bicep` | Optional orchestrator that references the modules below | - |
| `modules/vnet-with-nsg.bicep` | Hub-style VNet + tiered NSGs + AzureBastionSubnet | `02-platform-protection/templates/vnet-with-nsg.json` |
| `modules/app-gateway-waf.bicep` | App Gateway v2 with WAF_v2 policy | `02-platform-protection/templates/app-gateway-waf.json` |
| `modules/log-analytics-workspace.bicep` | Log Analytics workspace with daily cap | `03-security-operations/templates/log-analytics-workspace.json` |
| `modules/sentinel-workspace.bicep` | Enable Microsoft Sentinel on a workspace | `03-security-operations/templates/sentinel-workspace.json` |
| `modules/storage-account-encrypted.bicep` | Storage account with CMK + Private Endpoint | `04-data-protection/templates/storage-account-encrypted.json` |
| `modules/sql-database-secured.bicep` | Azure SQL Server + DB with Entra-only auth + auditing | `04-data-protection/templates/sql-database-secured.json` |
| `modules/azure-policy-definitions.bicep` | Custom policy definitions and assignment (sub scope) | `05-governance-compliance/templates/azure-policy-definitions.json` |
| `modules/rbac-assignments.bicep` | RBAC role assignment on a resource group | `01-identity-governance/templates/rbac-assignments.json` |

## Deploy examples

Resource-group scope:

```powershell
az deployment group create `
  --resource-group rg-sc500-lab `
  --template-file infra/modules/log-analytics-workspace.bicep `
  --parameters workspaceName=law-sc500-sentinel
```

Subscription scope (policies):

```powershell
az deployment sub create `
  --location westeurope `
  --template-file infra/modules/azure-policy-definitions.bicep `
  --parameters policyEffect=Audit
```

## Conventions

- Managed identities preferred over keys or connection strings.
- Key Vault modules keep soft delete and purge protection enabled.
- Storage accounts disable public network access and shared key access where practical.
- Always deploy diagnostic settings alongside a resource in real environments.
- API versions kept close to what the ARM templates already used, so behavior matches.

## Validate before deploy

Always run a preview:

```powershell
az deployment group what-if `
  --resource-group rg-sc500-lab `
  --template-file infra/modules/vnet-with-nsg.bicep
```
