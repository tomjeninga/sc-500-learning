# Lab 03: Sentinel Triage and KQL Investigation

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$1-3 (mostly Log Analytics ingestion if you generate test data)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will investigate a suspicious sign-in pattern, create or trigger a Sentinel
incident, triage the entities involved, and use KQL to determine scope and next
actions.

**Why this matters for SC-500:**
- SC-500 is not only about turning on Sentinel - it is about using it
- You must be able to pivot between **incident**, **entity**, and **log query**
- A common exam pattern is: **Which control detects it, and which workflow investigates it?**

**Investigation scenario:**

```text
User: bob-security
Signals:
  - Multiple failed sign-ins
  - Successful sign-in from unusual IP
  - New role assignment shortly after sign-in
Goal:
  Determine whether this is a likely account compromise and what to do next
```

---

## Prerequisites

- Domain 3 Lab 02 complete
- `law-sc500-sentinel` exists and has Microsoft Sentinel enabled
- Azure Activity and Entra ID connectors sending logs
- At least one test user such as `bob-security`

---

## Part 1: Create or simulate the suspicious activity

### Step 1.1 - Generate failed sign-ins

Use a test account and intentionally make several bad sign-in attempts from one
or more browsers/devices.

### Step 1.2 - Trigger a success

Then sign in successfully with the same account.

### Step 1.3 - Optional administrative action

If safe in your lab tenant, create a low-impact role assignment or resource
change so you also have correlated Azure Activity or AuditLogs data.

> If you do not want to generate real activity, use historical records already in
> your tenant and walk through the investigation path as a tabletop exercise.

---

## Part 2: Find the incident

### Step 2.1 - Review Analytics and Incidents

1. Open **Microsoft Sentinel**
2. Go to **Incidents**
3. Open the incident produced by your scheduled query rule from Lab 02, or create
   a simple test rule if needed

### Step 2.2 - Capture the key triage facts

Record:
- **Severity**
- **Entities** involved
- **Tactics** listed
- **Alert count**
- **Owner** and **status**

### Step 2.3 - Set the triage state

1. Assign the incident to yourself
2. Set status to **Active**
3. Add an initial comment describing the hypothesis:
   - `Possible password spray followed by successful sign-in`

---

## Part 3: Investigate with KQL

### Query 1 - Failed sign-ins for the user

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where UserPrincipalName =~ "bob-security@yourtenant.onmicrosoft.com"
| where ResultType != "0"
| summarize FailureCount = count(),
            FirstSeen = min(TimeGenerated),
            LastSeen = max(TimeGenerated),
            IPs = make_set(IPAddress)
```

### Query 2 - Successful sign-ins after failures

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where UserPrincipalName =~ "bob-security@yourtenant.onmicrosoft.com"
| project TimeGenerated, ResultType, ResultDescription, IPAddress, Location, AppDisplayName
| order by TimeGenerated desc
```

### Query 3 - Role changes tied to the user

```kql
AuditLogs
| where TimeGenerated > ago(7d)
| where OperationName has_any ("Add member to role", "Add eligible member to role")
| extend Actor = tostring(InitiatedBy.user.userPrincipalName)
| where Actor =~ "bob-security@yourtenant.onmicrosoft.com"
| project TimeGenerated, OperationName, Actor, TargetResources, ResultDescription
| order by TimeGenerated desc
```

### Query 4 - Related Azure Activity by caller

```kql
AzureActivity
| where TimeGenerated > ago(24h)
| where Caller =~ "bob-security@yourtenant.onmicrosoft.com"
| project TimeGenerated, Caller, OperationNameValue, ActivityStatusValue, ResourceGroup, ResourceId
| order by TimeGenerated desc
```

---

## Part 4: Pivot through entities

### Step 4.1 - Review the account entity

In the incident investigation graph or entity pane:

1. Open the **Account** entity
2. Review recent alerts, sign-ins, and related entities

### Step 4.2 - Review the IP entity

1. Open the **IP** entity
2. Check if it appears in multiple sign-ins or incidents
3. Record whether the IP is associated with expected geography

### Step 4.3 - Decide on the likely story

Choose the most likely interpretation:
- Benign user error
- Password spray / credential attack
- Compromised privileged account

Write down the evidence that supports your answer.

---

## Part 5: Choose containment and next steps

### Step 5.1 - Sentinel-side actions

Possible triage actions:
- Escalate severity
- Assign owner
- Add comments
- Link related incidents

### Step 5.2 - Source-system actions

Potential containment actions outside Sentinel:
- Reset password
- Revoke refresh tokens
- Block sign-in
- Remove recent privileged assignment
- Require stronger Conditional Access controls

> Sentinel helps you investigate and orchestrate. The actual containment often
> happens in Entra ID, Defender, or Azure RBAC.

---

## Validation Steps

Confirm you can answer all of these:

- Which logs proved the failed sign-ins?
- Which query showed whether the user later succeeded?
- Which log source showed a role assignment?
- What containment action would you take first?
- What evidence would justify closing the incident as benign?

---

## Exam traps

- **Sentinel** is the SIEM/SOAR plane; it does not replace Entra ID or Defender
- **Analytics rules** create alerts/incidents; **playbooks** automate response
- **KQL** is often the deciding skill in scenario questions
- **Defender XDR** may detect identity compromise, while **Sentinel** correlates broader tenant data

---

## Cleanup Instructions

1. Close the incident with notes after the exercise
2. Remove or disable any temporary test analytics rule you created
3. Revert any temporary role assignments used for simulation

---

## References

- <https://learn.microsoft.com/en-us/azure/sentinel/investigate-cases>
- <https://learn.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-built-in>
- <https://learn.microsoft.com/en-us/kusto/query/kusto-sentinel-overview?toc=%2Fazure%2Fsentinel%2FTOC.json&bc=%2Fazure%2Fsentinel%2Fbreadcrumb%2Ftoc.json>
