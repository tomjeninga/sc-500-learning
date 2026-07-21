# Domain 3 Study Guide: Security Operations

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Microsoft Defender for Cloud architecture and plans
- Secure Score: what it is and how to improve it
- Defender for Servers, Storage, SQL, Containers, Key Vault, App Service
- Microsoft Sentinel: workspace, connectors, analytics rules, workbooks, playbooks
- KQL (Kusto Query Language) basics for security analysis
- SIEM vs SOAR definitions and how Sentinel fulfils both roles

---

## 1. Microsoft Defender for Cloud

### What is Defender for Cloud?

Defender for Cloud is Microsoft's **Cloud Security Posture Management (CSPM)** and **Cloud Workload Protection Platform (CWPP)**:

- **CSPM:** Continuously evaluates your Azure resources against security best practices and provides a Secure Score
- **CWPP:** Detects threats and provides runtime protection for workloads (VMs, containers, databases, etc.)

> **Real-world context for platform engineers:** Defender for Cloud is your central security dashboard. It tells you which of your VMs are missing endpoint protection, which storage accounts have public access enabled, and generates alerts when a VM is under attack or when credentials are used from an unusual location.

### Defender for Cloud Plans

| Plan | What it Protects | Key Features |
| ------ | ----------------- | ------------- |
| **Foundational CSPM** | Azure resources posture | Secure Score, recommendations (free) |
| **Defender CSPM** | Multi-cloud posture | Attack path analysis, cloud security explorer, data sensitivity |
| **Defender for Servers Plan 1** | Azure VMs + on-prem | MDE integration, just-in-time VM access |
| **Defender for Servers Plan 2** | Azure VMs + Arc | Plan 1 + File integrity monitoring, 500 MB log allowance |
| **Defender for Storage** | Blob, Files, ADLS | Malware scanning, sensitive data threat detection |
| **Defender for SQL** | Azure SQL, SQL on VM | SQL vulnerability assessment, threat detection |
| **Defender for Containers** | AKS, ACR | Vulnerability assessment, runtime threat detection |
| **Defender for App Service** | Azure App Service | Anomaly detection, credential theft alerts |
| **Defender for Key Vault** | Key Vault | Suspicious access pattern alerts |
| **Defender for Resource Manager** | ARM operations | Suspicious deployment alerts |
| **Defender for DNS** | Azure DNS | DNS exfiltration detection |

> **Exam tip:** Know which plan covers which workload. "Defender for Servers" does NOT protect Azure SQL — that requires "Defender for SQL."

### Just-in-Time (JIT) VM Access

Part of Defender for Servers Plan 1/2:

- Management ports (22, 3389, 5985, 5986) are closed by default
- User requests access via Portal, API, or PowerShell
- Defender temporarily opens the port for the requester's IP only
- Access expires automatically (max 3 hours)

This dramatically reduces the attack surface for VM management.

---

## 2. Secure Score

### What is Secure Score?

Secure Score is a measurement (as a percentage) of how well your Azure environment aligns with security best practices. Higher score = better security posture.

**How it's calculated:**

- Microsoft publishes security controls (groups of related recommendations)
- Each control has a maximum score (e.g., "Enable MFA" = 10 points)
- You earn points by implementing the recommendations within a control
- Secure Score = (Points earned) / (Total possible points) × 100%

### Understanding Recommendations

Each Secure Score recommendation has:

- **Severity:** High / Medium / Low
- **Affected resources:** Which subscriptions/resources fail the check
- **Remediation steps:** How to fix it (Quick Fix button for some)
- **Freshness interval:** How often Defender rechecks (usually 30 min–24 hrs)

### Improving Secure Score

Priority order for maximum impact:

1. Fix all **High severity** recommendations
1. Focus on controls with most **potential score increase**
1. Enable MFA (highest score control in most tenants)
1. Enable Defender for Cloud plans (each plan adds recommendations)

---

## 3. Microsoft Sentinel

### What is Microsoft Sentinel?

Microsoft Sentinel is a **cloud-native SIEM (Security Information and Event Management)** and **SOAR (Security Orchestration, Automation, and Response)** solution.

| Capability | Description |
| ----------- | ------------- |
| **SIEM** | Collect, aggregate, and analyze security data from across your environment |
| **SOAR** | Automate responses to security incidents using playbooks (Logic Apps) |
| **Threat Intelligence** | Ingest threat feeds for IoC matching |
| **User Entity Behavior Analytics (UEBA)** | Detect anomalous behavior |

**Architecture:**

```text
Data Sources (connectors)
    ↓
Log Analytics Workspace (data store)
    ↓
Sentinel Analytics Rules (detection)
    ↓
Incidents (investigations)
    ↓
Playbooks / Automation Rules (response)
```text
### Log Analytics Workspace

Sentinel runs on top of a Log Analytics workspace. The workspace is where log data is stored in tables:

| Table | Data Source | Use Case |
| ------- | ------------- | --------- |
| `SecurityEvent` | Windows event logs | Logon events, process creation |
| `SigninLogs` | Entra ID | Sign-in success/failure, location |
| `AuditLogs` | Entra ID | User/role changes |
| `AzureActivity` | Azure Resource Manager | Resource create/delete/modify |
| `AzureFirewallApplicationRule` | Azure Firewall | Application-level firewall traffic |
| `StorageBlobLogs` | Azure Storage | Blob access patterns |
| `CommonSecurityLog` | CEF-based connectors | Third-party security devices |
| `Syslog` | Linux syslog | Linux VM events |

### Connectors

Connectors ingest data into Sentinel's Log Analytics workspace:

| Connector Type | Examples | Configuration |
| ---------------- | --------- | --------------- |
| **Native connectors** | Azure Activity, Entra ID, Defender for Cloud | One-click enable |
| **API connectors** | Microsoft 365 Defender, Defender for Cloud Apps | OAuth-based |
| **Agent-based** | Windows/Linux VMs, on-prem SIEM | Install MMA/AMA agent |
| **Common Event Format (CEF)** | Palo Alto, Fortinet firewalls | Syslog forwarder |
| **Syslog** | Linux appliances | Direct syslog or forwarder |

### Analytics Rules

Analytics rules define how Sentinel detects threats:

| Rule Type | Description | Use Case |
| ----------- | ------------- | --------- |
| **Scheduled** | KQL query runs on a schedule, creates incidents | Most custom detections |
| **Near Real-Time (NRT)** | Runs every minute | High-urgency detections |
| **Fusion** | ML-based correlation across multiple signals | Advanced multi-stage attacks |
| **Microsoft Security** | Creates incidents from Defender alerts | Import Defender alerts to Sentinel |
| **Anomaly** | ML baseline + anomaly detection | UEBA, unusual behavior |

---

## 4. KQL Basics

KQL (Kusto Query Language) is the query language for Log Analytics and Sentinel.

### Core Structure

```kql
TableName
| where Condition
| project Column1, Column2
| summarize Count = count() by Column
| order by Count desc
| take 10
```text
### Key Operators

| Operator | Description | Example |
| ---------- | ------------- | --------- |
| `where` | Filter rows | `where TimeGenerated > ago(1h)` |
| `project` | Select/rename columns | `project UserName, TimeGenerated` |
| `summarize` | Aggregate data | `summarize count() by bin(TimeGenerated, 1h)` |
| `extend` | Add calculated column | `extend Hour = bin(TimeGenerated, 1h)` |
| `order by` / `sort by` | Sort results | `order by TimeGenerated desc` |
| `take` / `limit` | Limit rows | `take 100` |
| `join` | Join tables | `join kind=inner` |
| `union` | Combine tables | `union SecurityEvent, AuditLogs` |
| `parse` | Extract fields | `parse EventData with ...` |
| `ago()` | Time ago function | `ago(24h)`, `ago(7d)` |

### Common Security Queries

**Failed sign-ins in last 24 hours:**

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType != "0"  // 0 = success
| summarize FailureCount = count() by UserPrincipalName, ResultDescription
| where FailureCount > 5
| order by FailureCount desc
```text
**Azure resource deletions:**

```kql
AzureActivity
| where TimeGenerated > ago(24h)
| where OperationNameValue endswith "delete"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, ResourceGroup, ResourceId, OperationNameValue
| order by TimeGenerated desc
```text
**VM sign-in failures:**

```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID == 4625  // Failed logon
| summarize FailureCount = count() by TargetAccount, IpAddress
| where FailureCount > 10  // Potential brute force
| order by FailureCount desc
```text
---

## 5. Playbooks and Automation

### What is a Playbook?

A playbook is a **Logic App** triggered by Sentinel alerts or incidents. It automates response actions:

**Example playbook flows:**

- Alert triggered → Block IP in firewall → Notify SOC via Teams
- Incident created → Get user manager → Send approval email → Disable account if approved
- Alert triggered → Enrich IP from threat intelligence → Update incident severity

### Automation Rules

Automation rules (simpler than playbooks) can:

- Automatically assign incidents to analysts
- Add tags to incidents
- Change incident severity or status
- Trigger playbooks
- Suppress noisy alerts

### Trigger Types

| Trigger | When Used |
| --------- | ---------- |
| **When an alert is created** | Run playbook immediately on alert |
| **When an incident is created** | Run on new incident creation |
| **When an incident is updated** | Run when incident changes (status, severity) |

---

## SIEM vs SOAR

| Aspect | SIEM | SOAR |
| -------- | ------ | ------ |
| Primary function | Collect, correlate, detect | Automate and orchestrate response |
| Data type | Logs, events | Alerts, incidents |
| Human involvement | High (analyst reviews) | Low (automation) |
| Azure service | Sentinel (analytics rules) | Sentinel (playbooks, automation rules) |
| Example action | Detect failed logins from unusual location | Block user, notify manager, create ticket |

Sentinel fulfils **both** SIEM and SOAR roles.

---

## Self-Check Questions

1. What is the difference between Defender for Cloud's CSPM and CWPP functionality?

1. Your Secure Score is 45%. The single recommendation "Enable MFA for users with administrative roles" would increase it by 12 points. What does this tell you about the recommendation?

1. Write a KQL query to find all Azure Resource Manager operations in the last 7 days where a resource group was deleted.

1. What is the difference between a Scheduled analytics rule and a Near Real-Time (NRT) rule?

1. Your SOC wants to automatically create a Microsoft Teams notification every time a Sentinel incident of High severity is created. What Sentinel feature do you use?

1. A junior analyst notices Sentinel is showing many false positive alerts from a known vulnerability scanner IP. How do you suppress these without disabling the analytics rule?

1. What Log Analytics table stores Azure Activity log data?

---

## Microsoft Learn Resources

- [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/)
- [Mitigate threats with Defender for Cloud](https://learn.microsoft.com/en-us/training/paths/sc-200-mitigate-threats-using-azure-defender/)
- [Microsoft Sentinel overview](https://learn.microsoft.com/en-us/azure/sentinel/overview)
- [Write KQL queries for Sentinel](https://learn.microsoft.com/en-us/training/modules/construct-kql-statements-microsoft-sentinel/)
- [Automate threat response with Sentinel playbooks](https://learn.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks)
