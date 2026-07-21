# Domain 3 Study Guide: Security Operations

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Microsoft Defender for Cloud architecture and plans
- Secure Score: what it is and how to improve it
- Defender for Servers, Storage, SQL, Containers, Key Vault, App Service
- Hybrid and multicloud coverage with Azure Arc, AWS, and GCP connectors
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
|------|-----------------|-------------|
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

### Hybrid and multicloud posture

Defender for Cloud is not limited to Azure-native resources.

- **On-premises and non-Azure servers** can be connected by using **Azure Arc**
- **AWS accounts** and **GCP projects** can be connected through native multicloud connectors
- Once connected, Defender for Cloud can surface posture recommendations and, when enabled, workload protection for supported resources

**Why this matters on the exam:**
- SC-500 questions often test whether you know the correct onboarding bridge for hybrid resources
- The key design distinction is whether you need **posture visibility only** or **deeper workload protection**

### Azure Arc for servers

Azure Arc is the recommended onboarding path for non-Azure servers when you want them governed and protected in Azure as first-class resources.

| Choice | Best use |
| --- | --- |
| **Azure Arc onboarding** | Preferred for hybrid and multicloud servers that need broader Defender for Servers capabilities |
| **Direct onboarding with Defender for Endpoint** | Useful if Arc is not feasible, but not the best path for the full Plan 2 story |

### Multicloud connectors

The native connectors for **AWS** and **GCP** bring those environments into Defender for Cloud for posture assessment. If you also enable server protection plans, Azure Arc can be autoprovisioned for supported machines discovered in those clouds.

**Authentication model:**
- AWS and GCP connectors use **federated trust**, not long-lived saved secrets

### CSPM vs CWPP in multicloud

| Need | Best answer |
| --- | --- |
| Posture, standards, recommendations, secure score | **CSPM** |
| Machine threat protection and runtime coverage | **Defender for Servers** |
| Kubernetes workload protection | **Defender for Containers** |

### Defender for Servers plan choice in hybrid scenarios

| Plan | What to remember |
| --- | --- |
| **Plan 1** | Entry-level EDR-focused server protection |
| **Plan 2** | Adds richer posture and hardening capabilities such as agentless scanning, FIM, JIT, OS configuration assessment, and free ingestion benefits for supported data types |

> **Exam tip:** For hybrid or multicloud server scenarios, Azure Arc is usually the cleanest answer when the question wants the broadest Defender for Servers capability set.

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
2. Focus on controls with most **potential score increase**
3. Enable MFA (highest score control in most tenants)
4. Enable Defender for Cloud plans (each plan adds recommendations)

### Secure Score in multicloud

When AWS and GCP environments are connected, Defender for Cloud can assess those environments against supported standards and include their posture in your broader risk picture. The exact recommendation coverage depends on the connected environment and enabled plans.

---

## 3. Microsoft Sentinel

### What is Microsoft Sentinel?

Microsoft Sentinel is a **cloud-native SIEM (Security Information and Event Management)** and **SOAR (Security Orchestration, Automation, and Response)** solution.

| Capability | Description |
|-----------|-------------|
| **SIEM** | Collect, aggregate, and analyze security data from across your environment |
| **SOAR** | Automate responses to security incidents using playbooks (Logic Apps) |
| **Threat Intelligence** | Ingest threat feeds for IoC matching |
| **User Entity Behavior Analytics (UEBA)** | Detect anomalous behavior |

**Architecture:**
```
Data Sources (connectors)
    ↓
Log Analytics Workspace (data store)
    ↓
Sentinel Analytics Rules (detection)
    ↓
Incidents (investigations)
    ↓
Playbooks / Automation Rules (response)
```

### Log Analytics Workspace

Sentinel runs on top of a Log Analytics workspace. The workspace is where log data is stored in tables:

| Table | Data Source | Use Case |
|-------|-------------|---------|
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
|----------------|---------|---------------|
| **Native connectors** | Azure Activity, Entra ID, Defender for Cloud | One-click enable |
| **API connectors** | Microsoft 365 Defender, Defender for Cloud Apps | OAuth-based |
| **Agent-based** | Windows/Linux VMs, on-prem SIEM | Install MMA/AMA agent |
| **Common Event Format (CEF)** | Palo Alto, Fortinet firewalls | Syslog forwarder |
| **Syslog** | Linux appliances | Direct syslog or forwarder |

### Content Hub

Content hub is the packaging and deployment surface for Microsoft Sentinel
solutions. A solution can install:

- Data connectors
- Analytics rules
- Workbooks
- Parsers
- Playbooks

Use Content hub when Microsoft or a vendor provides a packaged solution for the
scenario. Do not confuse this with the underlying ingestion method. A solution
often still depends on a connector, DCR, AMA, API auth, or diagnostic settings.

### Data Collection Rules (DCRs) and AMA

For agent-based collection, Microsoft Sentinel increasingly relies on the
**Azure Monitor Agent (AMA)** and **Data Collection Rules (DCRs)**.

| Component | Purpose |
|-----------|---------|
| **AMA** | Runs on a VM or forwarder and collects the logs |
| **DCR** | Defines what to collect and where to send it |
| **Connector** | Exposes the supported setup experience in Sentinel |

Common SC-500 ingestion patterns:

- **Windows Security Events via AMA** -> `SecurityEvent`
- **Syslog via AMA** -> `Syslog`
- **CEF via AMA** -> `CommonSecurityLog`
- **Custom logs** or **Logs Ingestion API** -> custom schema when a built-in path does not fit

> **Exam tip:** If the source is a VM, forwarder, or machine-level log source, think **AMA + DCR** before you think custom connector.

### Analytics Rules

Analytics rules define how Sentinel detects threats:

| Rule Type | Description | Use Case |
|-----------|-------------|---------|
| **Scheduled** | KQL query runs on a schedule, creates incidents | Most custom detections |
| **Near Real-Time (NRT)** | Runs every minute | High-urgency detections |
| **Fusion** | ML-based correlation across multiple signals | Advanced multi-stage attacks |
| **Microsoft Security** | Creates incidents from Defender alerts | Import Defender alerts to Sentinel |
| **Anomaly** | ML baseline + anomaly detection | UEBA, unusual behavior |

### Data connector strategy

Use this quick decision model:

| If the source is... | Start with... |
|---------------------|---------------|
| Microsoft-native cloud service | Native connector or diagnostic settings |
| Windows event source | Windows Security Events via AMA |
| Linux or appliance syslog source | Syslog via AMA |
| Security appliance producing CEF | CEF via AMA |
| Unsupported or custom application log | Custom logs or Logs Ingestion API |

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
```

### Key Operators

| Operator | Description | Example |
|----------|-------------|---------|
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
```

**Azure resource deletions:**
```kql
AzureActivity
| where TimeGenerated > ago(24h)
| where OperationNameValue endswith "delete"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, ResourceGroup, ResourceId, OperationNameValue
| order by TimeGenerated desc
```

**VM sign-in failures:**
```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID == 4625  // Failed logon
| summarize FailureCount = count() by TargetAccount, IpAddress
| where FailureCount > 10  // Potential brute force
| order by FailureCount desc
```

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
- Add task lists for analysts

### Trigger Types

| Trigger | When Used |
|---------|----------|
| **When an alert is created** | Run playbook immediately on alert |
| **When an incident is created** | Run on new incident creation |
| **When an incident is updated** | Run when incident changes (status, severity) |

### Sentinel permission model for automation

There are two permission paths to keep separate:

1. **Microsoft Sentinel service permission to trigger the playbook**
    - Typically granted with **Microsoft Sentinel Automation Contributor** on the resource group that contains the playbook
2. **Playbook permission to act on Sentinel or other resources**
    - Prefer a **managed identity** on the Logic App
    - Grant only the minimum role such as **Microsoft Sentinel Reader** or **Microsoft Sentinel Responder**

> **Exam tip:** A playbook that updates incidents needs more than just the permission for Sentinel to call it. The Logic App itself also needs the right access.

### Logic Apps security for Sentinel playbooks

When Sentinel uses Azure Logic Apps as playbooks, secure them like any other application workload:

- Prefer **system-assigned managed identity** over broad user-based connections
- Minimize connector sprawl and remove unused actions
- Avoid giving **Contributor** at broad scope when a Sentinel-specific role is enough
- Review workflow run history and automation health when a playbook fails

---

## 6. Hybrid and Multicloud Design Notes

### On-premises servers

- Recommended onboarding path: **Azure Arc-enabled servers**
- Defender for Cloud then sees the machine as an Azure resource
- Defender for Servers can extend workload protection to that machine

### AWS and GCP

- Use **Defender for Cloud native connectors** for AWS accounts and GCP projects
- Start with **CSPM** if the need is posture visibility and recommendations
- Add **Defender for Servers** or **Defender for Containers** only when you need workload-level protection

### Cost and permission thinking

- Every extra Defender plan can add cost
- AWS and GCP connectors also require cloud-side permissions that should be reviewed carefully
- For AWS, CSPM read-only API activity can increase CloudTrail volume if you export read events to another SIEM

### Common wrong answers

- Choosing Sentinel when the requirement is posture management
- Choosing Defender for Servers when the requirement is only policy and recommendations
- Choosing direct Defender for Endpoint onboarding when the question wants full hybrid onboarding breadth

---

## SIEM vs SOAR

| Aspect | SIEM | SOAR |
|--------|------|------|
| Primary function | Collect, correlate, detect | Automate and orchestrate response |
| Data type | Logs, events | Alerts, incidents |
| Human involvement | High (analyst reviews) | Low (automation) |
| Azure service | Sentinel (analytics rules) | Sentinel (playbooks, automation rules) |
| Example action | Detect failed logins from unusual location | Block user, notify manager, create ticket |

Sentinel fulfils **both** SIEM and SOAR roles.

---

## Self-Check Questions

1. What is the difference between Defender for Cloud's CSPM and CWPP functionality?

2. Your Secure Score is 45%. The single recommendation "Enable MFA for users with administrative roles" would increase it by 12 points. What does this tell you about the recommendation?

3. Write a KQL query to find all Azure Resource Manager operations in the last 7 days where a resource group was deleted.

4. What is the difference between a Scheduled analytics rule and a Near Real-Time (NRT) rule?

5. Your SOC wants to automatically create a Microsoft Teams notification every time a Sentinel incident of High severity is created. What Sentinel feature do you use?

6. A junior analyst notices Sentinel is showing many false positive alerts from a known vulnerability scanner IP. How do you suppress these without disabling the analytics rule?

7. What Log Analytics table stores Azure Activity log data?

8. What is the difference between a Content hub solution and a data connector?

9. When would you use a DCR with AMA instead of a service-to-service connector?

10. Which Sentinel role lets a playbook update incidents: Reader or Responder?

11. What is the recommended onboarding path for non-Azure servers when you want the fullest Defender for Servers capabilities?

12. If a scenario only asks for multicloud posture recommendations and standards coverage, do you start with CSPM or Defender for Servers?

13. Why might Azure Arc still appear in an AWS or GCP Defender for Servers design?

---

## Microsoft Learn Resources

- [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/)
- [Mitigate threats with Defender for Cloud](https://learn.microsoft.com/en-us/training/paths/sc-200-mitigate-threats-using-azure-defender/)
- [Connect non-Azure machines to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-machines)
- [Connect AWS accounts to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-aws)
- [Connect GCP projects to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-gcp)
- [Select a Defender for Servers plan and deployment scope](https://learn.microsoft.com/en-us/azure/defender-for-cloud/plan-defender-for-servers-select-plan)
- [Microsoft Sentinel overview](https://learn.microsoft.com/en-us/azure/sentinel/overview)
- [Deploy and manage out-of-the-box content in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-solutions-deploy)
- [Ingest Windows Security Events by using AMA](https://learn.microsoft.com/en-us/azure/sentinel/connect-windows-security-events)
- [Ingest Syslog and CEF messages to Microsoft Sentinel with AMA](https://learn.microsoft.com/en-us/azure/sentinel/connect-cef-syslog-ama)
- [Kusto Query Language overview for Microsoft Sentinel](https://learn.microsoft.com/en-us/kusto/query/kusto-sentinel-overview?toc=%2Fazure%2Fsentinel%2FTOC.json&bc=%2Fazure%2Fsentinel%2Fbreadcrumb%2Ftoc.json)
- [Automate threat response with Sentinel playbooks](https://learn.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks)
- [Authenticate playbooks to Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/automation/authenticate-playbooks-to-sentinel)
