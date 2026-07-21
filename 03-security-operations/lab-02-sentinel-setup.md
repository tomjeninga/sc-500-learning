# Lab 02: Microsoft Sentinel Setup

## Overview

**Estimated Time:** 60–90 minutes  
**Estimated Cost:** ~$2–5 (Log Analytics ingestion at ~$2.76/GB; free 5 GB/day trial period for new workspaces). Sentinel adds ~$2.46/GB ingested after free tier.  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will deploy a Log Analytics workspace, onboard Microsoft Sentinel, configure the Azure Activity and Entra ID connectors, create a scheduled analytics rule, and run KQL queries to analyze security data.

**Why this matters:**
- Sentinel deployment and configuration is heavily tested on SC-500
- KQL query writing is directly tested — you must be able to write basic queries
- Understanding analytics rule configuration (query, frequency, threshold) is examinable

**Architecture:**

```
Azure Activity (subscription logs)
Entra ID Sign-in logs
            ↓
[Log Analytics Workspace: law-sc500-sentinel]
            ↓
[Microsoft Sentinel]
  ├── Analytics Rule: Detect admin sign-in failures
  ├── Workbook: Azure Activity overview
  └── Incident: Created when rule triggers
```

---

> **Depends on:** `rg-sc500-lab`, appropriate Azure and Entra permissions, and willingness to keep a Log Analytics workspace active through the next Sentinel lab
> **Reused by:** `03-security-operations/lab-03-sentinel-triage-investigation.md` and optional SQL auditing in `04-data-protection/lab-02-database-security.md`
> **Delete after:** you complete the triage lab and any other logging exercises that still need `law-sc500-sentinel`

## Prerequisites

- Azure subscription with Owner or Security Admin role
- `rg-sc500-lab` resource group
- Microsoft 365 / Entra ID P1 or P2 (for Entra ID connector)

---

## Part 1: Deploy Log Analytics Workspace

### Step 1.1 — Create the workspace

1. In Azure Portal, search for **Log Analytics workspaces** → **+ Create**
2. Configure:
   - **Subscription:** Your subscription
   - **Resource group:** `rg-sc500-lab`
   - **Name:** `law-sc500-sentinel`
   - **Region:** East US
3. Click **Review + create** → **Create**

### Step 1.2 — Review workspace settings

4. Once deployed, open `law-sc500-sentinel`
5. Review:
   - **Overview:** Workspace ID, Resource ID
   - **Agents:** Review agent onboarding options, noting that Azure Monitor Agent (AMA) is the current agent
   - **Advanced settings:** Workspace ID and Primary key (legacy agent onboarding details still appear here)

---

## Part 2: Enable Microsoft Sentinel

### Step 2.1 — Add Sentinel to the workspace

1. Search for **Microsoft Sentinel** → **+ Create**
2. Select `law-sc500-sentinel` from the list
3. Click **Add Microsoft Sentinel**
4. ✅ Sentinel is now enabled on your workspace

> Note: The first 10 GB per month ingested to a Sentinel workspace is free for the first 31 days (trial). After that, you're charged per GB ingested.

---

## Part 3: Configure Data Connectors

### Step 3.1 — Enable Azure Activity connector

1. In Sentinel left menu, click **Data connectors**
2. Search for **Azure Activity**
3. Click **Azure Activity** → **Open connector page**
4. Click **Configure Azure Activity logs**
5. In the Diagnostic settings blade:
   - Select your subscription
   - Under **Destination details**: check **Send to Log Analytics workspace**
   - Select `law-sc500-sentinel`
   - Check all available log categories (AuditLogs, Administrative, etc.)
6. Click **Save**
7. Return to the connector page — status should show **Connected**

### Step 3.2 — Enable Entra ID connector

1. In Data connectors, search for **Microsoft Entra ID**
2. Click **Microsoft Entra ID** → **Open connector page**
3. Under **Connect Logs**, enable:
   - **Sign-in Logs**
   - **Audit Logs**
4. Click **Apply changes**
5. ✅ Status should show logs are flowing

---

## Part 4: Create an Analytics Rule

### Step 4.1 — Create a Scheduled Analytics Rule

1. In Sentinel, click **Analytics** → **+ Create** → **Scheduled query rule**
2. **General tab:**
   - **Name:** `Admin Sign-in Failure Threshold`
   - **Description:** Detects when an admin account has more than 5 failed sign-ins in 15 minutes
   - **Severity:** High
   - **Tactics:** Credential Access, Initial Access
3. Click **Next: Set rule logic**

### Step 4.2 — Configure the KQL Query

4. In the **Rule query** box, enter:

```kql
SigninLogs
| where TimeGenerated > ago(15m)
| where ResultType != "0"
| where UserPrincipalName has_any ("admin", "global", "privileged", "security")
    or UserType == "Admin"
| summarize FailureCount = count(), 
            LastAttempt = max(TimeGenerated),
            Locations = make_set(Location)
    by UserPrincipalName, AppDisplayName, IPAddress
| where FailureCount >= 5
| project UserPrincipalName, IPAddress, AppDisplayName, FailureCount, LastAttempt, Locations
```

5. Click **View query results** to test the query

### Step 4.3 — Configure Rule Settings

6. **Alert enhancement:**
   - **Entity mapping:**
     - Add entity: Account → UserPrincipalName
     - Add entity: IP → IPAddress

7. **Query scheduling:**
   - **Run query every:** 15 minutes
   - **Lookup data from:** Last 15 minutes

8. **Alert threshold:**
   - **Generate alert when number of query results:** Is greater than 0

9. **Event grouping:** Group all events into a single alert

10. Click **Next: Incident settings**

### Step 4.4 — Configure Incident Settings

11. **Incident settings:**
    - **Create incidents from alerts triggered by this analytics rule:** Enabled
12. Click **Next: Automated response**

### Step 4.5 — Configure Automated Response (optional)

13. You can leave this empty for now, or add an automation rule to assign incidents automatically
14. Click **Next: Review** → **Save**

---

## Part 5: Run KQL Queries

Navigate to Sentinel → **Logs** to run the following queries.

### Query 1: All Azure activity in last 24 hours

```kql
AzureActivity
| where TimeGenerated > ago(24h)
| summarize OperationCount = count() by OperationNameValue, ActivityStatusValue
| order by OperationCount desc
| take 20
```

### Query 2: Resource deletions

```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationNameValue endswith "/delete"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, ResourceGroup, ResourceId, OperationNameValue
| order by TimeGenerated desc
```

### Query 3: Sign-in failures from multiple locations

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType != "0"
| summarize FailureCount = count(), 
            UniqueLocations = dcount(Location)
    by UserPrincipalName
| where UniqueLocations >= 3
| project UserPrincipalName, FailureCount, UniqueLocations
| order by FailureCount desc
```

### Query 4: New role assignments in last 7 days

```kql
AuditLogs
| where TimeGenerated > ago(7d)
| where OperationName == "Add member to role"
| extend 
    Target = tostring(TargetResources[0].userPrincipalName),
    Role   = tostring(TargetResources[0].modifiedProperties[0].newValue)
| project TimeGenerated, InitiatedBy = InitiatedBy.user.userPrincipalName, Target, Role
```

---

## Part 6: Review Sentinel Workbooks

### Step 6.1 — Enable Azure Activity workbook

1. In Sentinel, click **Workbooks** → **Templates**
2. Search for **Azure Activity**
3. Click it → **View template**
4. ✅ Review the pre-built visualizations (operations over time, top callers, etc.)
5. Click **Save** to create an editable copy

---

## ARM Template Deployment

```bash
# Deploy Log Analytics workspace
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/log-analytics-workspace.json \
  --parameters workspaceName=law-sc500-sentinel location=eastus

# Enable Sentinel on the workspace
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/sentinel-workspace.json \
  --parameters workspaceName=law-sc500-sentinel
```

```powershell
# Deploy Log Analytics workspace
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\log-analytics-workspace.json" `
  -workspaceName "law-sc500-sentinel" `
  -location "eastus"

# Enable Sentinel
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\sentinel-workspace.json" `
  -workspaceName "law-sc500-sentinel"
```

---

## Validation Steps

```powershell
# Verify Log Analytics workspace
$workspace = Get-AzOperationalInsightsWorkspace -Name "law-sc500-sentinel" -ResourceGroupName "rg-sc500-lab"
Write-Host "Workspace: $($workspace.Name) - Sku: $($workspace.Sku) - Location: $($workspace.Location)"

# Check if Sentinel is enabled (look for SecurityInsights solution)
$solutions = Get-AzOperationalInsightsIntelligencePack -ResourceGroupName "rg-sc500-lab" -WorkspaceName "law-sc500-sentinel"
$sentinel = $solutions | Where-Object { $_.Name -eq "SecurityInsights" }
Write-Host "Sentinel enabled: $($sentinel.Enabled)"
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| SigninLogs table empty | Entra ID connector not configured | Verify connector shows "Connected" in Data connectors |
| AzureActivity table empty | Diagnostic settings delay | Wait 15 min; check Diagnostic settings on subscription |
| Analytics rule not creating incidents | Threshold too high | Test query first; lower threshold or use "Is greater than 0" |
| Query returns no results | No matching data yet | Change time range to `ago(7d)` or check connector status |

---

## Cleanup Instructions

```powershell
$rg = "rg-sc500-lab"
$workspaceName = "law-sc500-sentinel"

# Remove Sentinel (removes the SecurityInsights solution)
# Note: You'll need to do this via Portal: Sentinel → Settings → Remove Microsoft Sentinel

# Remove Log Analytics workspace
Remove-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $rg -Force

Write-Host "Sentinel workspace removed."
```

> Note: In the Portal — Sentinel → Settings → scroll to bottom → **Remove Microsoft Sentinel** before deleting the workspace.

---

## Key Takeaways

- Sentinel runs on top of a **Log Analytics workspace** — the workspace is the data store
- **Connectors** ingest data; data is stored in tables (`AzureActivity`, `SigninLogs`, etc.)
- **Analytics rules** define detections using KQL queries
- **Incidents** are created when analytics rules trigger
- KQL basics: `where`, `summarize`, `project`, `order by`, `take`
- Sentinel provides both **SIEM** (detection via analytics rules) and **SOAR** (response via playbooks)
