# SC-500 KQL Workbook

Reusable KQL queries for the four SC-500 skill areas. Paste into **Log Analytics** (workspace with Sentinel + Defender for Cloud connectors) or into a **Microsoft Sentinel Workbook**.

Naming convention: each query header is `// [Area] [What it answers]` so you can grep for `// [Identity]` etc.

> Tip: many of these queries assume the following data connectors are enabled:
> - Microsoft Entra ID (SigninLogs, AuditLogs, IdentityInfo)
> - Microsoft Defender for Cloud (SecurityAlert, SecurityRecommendation, SecurityRegulatoryCompliance)
> - Azure Activity (AzureActivity)
> - Azure Firewall / NSG flow logs (AZFWNetworkRule, AzureNetworkAnalytics_CL)
> - Microsoft 365 Defender (via XDR connector: EmailEvents, CloudAppEvents, DeviceProcessEvents)

---

## 1. Identity, Access, and Governance (20-25%)

```kql
// [Identity] Failed sign-ins by user in last 24h
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType != 0
| summarize FailedAttempts = count(),
            DistinctIPs   = dcount(IPAddress),
            LastFailure   = max(TimeGenerated)
    by UserPrincipalName, ResultType, ResultDescription
| order by FailedAttempts desc
```

```kql
// [Identity] Risky sign-ins (Entra ID Protection) trending
SigninLogs
| where TimeGenerated > ago(7d)
| where RiskLevelDuringSignIn in ("medium", "high")
| summarize count() by bin(TimeGenerated, 1h), RiskLevelDuringSignIn
| render timechart
```

```kql
// [Identity] PIM role activations - who elevated what and when
AuditLogs
| where TimeGenerated > ago(30d)
| where Category == "RoleManagement"
| where OperationName has_any ("Add member to role completed (PIM activation)",
                              "Add eligible member to role")
| project TimeGenerated,
          Actor      = tostring(InitiatedBy.user.userPrincipalName),
          Role       = tostring(TargetResources[0].displayName),
          Reason     = tostring(AdditionalDetails[0].value),
          Result     = ResultDescription
| order by TimeGenerated desc
```

```kql
// [Identity] Standing privileged access - roles assigned as Active (not Eligible)
IdentityInfo
| where AssignedRoles contains "Global Administrator"
   or AssignedRoles contains "Privileged Role Administrator"
   or AssignedRoles contains "Security Administrator"
| project AccountUPN, AssignedRoles, TimeGenerated
| distinct AccountUPN, AssignedRoles
```

```kql
// [Identity] Conditional Access failures (grant not satisfied)
SigninLogs
| where TimeGenerated > ago(24h)
| where ConditionalAccessStatus == "failure"
| extend AppliedCA = tostring(ConditionalAccessPolicies)
| project TimeGenerated, UserPrincipalName, AppDisplayName, IPAddress,
          ResultDescription, AppliedCA
| order by TimeGenerated desc
```

---

## 2. Secure Storage, Databases, and Networking (25-30%)

```kql
// [Storage] Anonymous / SAS-based data-plane operations on Storage
StorageBlobLogs
| where TimeGenerated > ago(24h)
| where AuthenticationType in ("Anonymous", "SAS")
| summarize count(), UniqueIPs = dcount(CallerIpAddress)
    by AccountName, AuthenticationType, StatusText
| order by count_ desc
```

```kql
// [SQL] Defender for SQL alerts + who was targeted
SecurityAlert
| where TimeGenerated > ago(7d)
| where ResourceType == "SqlServers" or ProductName has "SQL"
| project TimeGenerated, AlertName, AlertSeverity, ResourceId = tostring(Entities),
          Description
| order by AlertSeverity asc, TimeGenerated desc
```

```kql
// [Network] NSG flow denies aggregated by source
AzureNetworkAnalytics_CL
| where SubType_s == "FlowLog"
| where FlowStatus_s == "D"           // Denied
| summarize DeniedFlows = count(),
            Bytes = sum(OutboundBytes_d + InboundBytes_d)
    by SrcIP_s, DestPort_d
| top 25 by DeniedFlows desc
```

```kql
// [Network] Azure Firewall - top blocked FQDNs
AZFWApplicationRule
| where TimeGenerated > ago(24h)
| where Action == "Deny"
| summarize DenyCount = count() by Fqdn, SourceIp
| top 25 by DenyCount
```

```kql
// [Network] DDoS Protection - attacks and mitigation
AzureDiagnostics
| where ResourceType == "PUBLICIPADDRESSES"
| where Category == "DDoSProtectionNotifications" or Category == "DDoSMitigationReports"
| project TimeGenerated, Resource, Category, msg_s
| order by TimeGenerated desc
```

---

## 3. Secure Compute (includes AI security) (20-25%)

```kql
// [Compute] Defender for Servers - alerts on VMs
SecurityAlert
| where TimeGenerated > ago(7d)
| where ResourceType == "VirtualMachine"
| project TimeGenerated, AlertName, AlertSeverity, CompromisedEntity, RemediationSteps
| order by AlertSeverity asc, TimeGenerated desc
```

```kql
// [Compute] JIT VM access requests
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationNameValue has "Microsoft.Security/locations/jitNetworkAccessPolicies/initiate"
| project TimeGenerated, Caller, ResourceGroup, Resource, ActivityStatusValue
| order by TimeGenerated desc
```

```kql
// [Compute] VM extension installs - watch for suspicious ones (CustomScriptExtension, RunCommand)
AzureActivity
| where TimeGenerated > ago(24h)
| where OperationNameValue has "Microsoft.Compute/virtualMachines/extensions/write"
| extend ExtName = tostring(parse_json(Properties).resource)
| where ExtName has_any ("CustomScript", "RunCommand", "runShellScript")
| project TimeGenerated, Caller, ResourceGroup, Resource, ExtName, ActivityStatusValue
```

```kql
// [AI] Defender for AI Service alerts (jailbreaks, prompt injection, credential leaks)
SecurityAlert
| where TimeGenerated > ago(7d)
| where ProductName has_any ("Defender for AI", "AI workload", "AI Services")
   or AlertName has_any ("jailbreak", "prompt injection", "sensitive data exposure")
| project TimeGenerated, AlertName, AlertSeverity, ProductName, Description, Entities
| order by TimeGenerated desc
```

```kql
// [AI] Azure OpenAI / Foundry diagnostic - abnormal call volume by model
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| summarize CallCount = count(),
            AvgTokens = avg(todouble(properties_totalTokens_d))
    by bin(TimeGenerated, 15m), modelDeploymentName_s, CallerIpAddress
| where CallCount > 100
| order by CallCount desc
```

```kql
// [AI] Copilot/agent audit trail (Microsoft 365 audit)
CloudAppEvents
| where TimeGenerated > ago(7d)
| where Application has_any ("Copilot", "Microsoft 365 Copilot", "Copilot Studio")
| project TimeGenerated, AccountObjectId, ActionType, Application, RawEventData
| order by TimeGenerated desc
```

---

## 4. Manage and Monitor Security Posture (20-25%)

```kql
// [Posture] Unhealthy Defender for Cloud recommendations by severity
SecurityRecommendation
| where TimeGenerated > ago(1d)
| where RecommendationState == "Unhealthy"
| summarize UnhealthyResources = count()
    by RecommendationName, RecommendationSeverity
| order by RecommendationSeverity asc, UnhealthyResources desc
```

```kql
// [Posture] Regulatory compliance drift over time (e.g., ISO 27001, PCI, NIST 800-53)
SecurityRegulatoryCompliance
| where TimeGenerated > ago(30d)
| summarize PassedControls = countif(State == "Passed"),
            FailedControls = countif(State == "Failed")
    by bin(TimeGenerated, 1d), ComplianceStandard
| render timechart
```

```kql
// [Posture] Secure Score trend
SecureScores
| where TimeGenerated > ago(90d)
| summarize AvgScore = avg(PercentageScore) by bin(TimeGenerated, 1d)
| render timechart
```

```kql
// [Posture] Top 10 resources by open high-severity recommendations
SecurityRecommendation
| where RecommendationState == "Unhealthy"
| where RecommendationSeverity == "High"
| summarize OpenRecs = count() by AssessedResourceId
| top 10 by OpenRecs desc
```

```kql
// [Posture] Sentinel incidents open longer than 24h (aging incidents)
SecurityIncident
| where Status != "Closed"
| extend AgeHours = datetime_diff("hour", now(), CreatedTime)
| where AgeHours > 24
| project IncidentNumber, Title, Severity, Owner, AgeHours, CreatedTime
| order by Severity asc, AgeHours desc
```

---

## Exam-day mental model

- **`SigninLogs` / `AuditLogs`** → identity questions.
- **`SecurityAlert`** → any "Defender detected X" question. Filter by `ProductName` to distinguish Defender products.
- **`SecurityRecommendation` + `SecureScores`** → posture questions (never `SecurityAlert` for posture).
- **`AzureDiagnostics` with `MICROSOFT.COGNITIVESERVICES`** → AI observability.
- **`CloudAppEvents`** → M365 Copilot / SaaS.
