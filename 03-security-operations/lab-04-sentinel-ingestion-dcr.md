# Lab 04: Sentinel Ingestion with AMA, DCR, and Content Hub

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$1-4 depending on VM runtime and log volume  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will extend your Microsoft Sentinel workspace beyond Azure Activity and Entra
logs by installing a Content hub solution, configuring a data collection rule
(DCR), and ingesting Windows Security Events from a test VM by using the Azure
Monitor Agent (AMA). You will also compare this path to Syslog, CEF, and custom
log ingestion.

**Why this matters for SC-500:**
- The exam expects you to know more than just the built-in Azure connectors
- Microsoft Sentinel now relies heavily on **AMA + DCR** patterns for agent-based ingestion
- Candidates often confuse **Content hub solutions**, **data connectors**, **DCRs**, and **custom log tables**

**Architecture:**

```text
Microsoft Sentinel Content hub
        |
        | installs solution / connector package
        v
Data connector -> DCR -> Azure Monitor Agent on VM
                                |
                                v
                     Windows Security Events
                                |
                                v
                    [Log Analytics Workspace: law-sc500-sentinel]
                                |
                                v
                        SecurityEvent table
```

---

> **Depends on:** `03-security-operations/lab-02-sentinel-setup.md` and a Windows VM you can onboard with AMA
> **Reused by:** `03-security-operations/lab-03-sentinel-triage-investigation.md`, `03-security-operations/lab-05-sentinel-automation-playbooks.md`, and later hunting or analytics exercises that need richer event data
> **Delete after:** you finish the Sentinel labs that still need the AMA-connected source or its extra ingestion volume

## Prerequisites

- `law-sc500-sentinel` exists and has Microsoft Sentinel enabled
- Owner, Contributor, or appropriate monitoring permissions on the VM and workspace
- A Windows VM in Azure or another reachable machine you can use for Windows Security Events
- Optional: a Linux log forwarder if you want to compare Syslog or CEF hands-on later

---

## Part 1: Review the ingestion choices

Before you configure anything, build this mental map:

| Ingestion path | Best fit | Common tables |
| --- | --- | --- |
| Service-to-service connector | Microsoft-native sources like Entra ID or Defender | `SigninLogs`, `AuditLogs`, `SecurityAlert` |
| AMA + DCR | Windows events, Syslog, CEF, VM-collected logs | `SecurityEvent`, `Syslog`, `CommonSecurityLog` |
| Diagnostic settings | Azure platform resources | `AzureActivity`, `AzureDiagnostics`, resource-specific tables |
| Custom logs / ingestion API | Data that does not fit built-in connectors | Custom table ending in `_CL` or DCR-based custom schema |

**Memorize this rule:**
- If the source is a machine or forwarder, think **AMA + DCR**
- If the source is an Azure or Microsoft service, first check for a **native connector**
- If no native connector exists, evaluate **custom logs** or the **Logs Ingestion API**

---

## Part 2: Use Content hub to understand solution-based onboarding

### Step 2.1 - Open Content hub

1. In Microsoft Sentinel, open **Content hub**
2. Search for solutions such as:
   - **Syslog**
   - **Common Event Format (CEF)**
   - A vendor or platform solution you recognize

### Step 2.2 - Inspect what a solution installs

1. Open a solution details page
2. Review which content items it includes, such as:
   - Data connectors
   - Analytics rules
   - Workbooks
   - Playbooks
   - Parsers

### Step 2.3 - Install one low-risk solution

For lab purposes, install a small solution if available in your tenant and note:

- Which connector it expects
- Whether it depends on AMA, Syslog, CEF, API, or a native service connection
- Which content items become available afterward

> The exam may describe Content hub as the place where you deploy packaged Sentinel content, not the place where raw Windows events are stored.

---

## Part 3: Configure Windows Security Events via AMA and DCR

### Step 3.1 - Open the connector

1. In Sentinel, open **Data connectors**
2. Search for **Windows Security Events via AMA**
3. Open the connector page

### Step 3.2 - Create a DCR

1. Click **+ Create data collection rule**
2. Configure:
   - **Name:** `dcr-sc500-securityevents`
   - **Subscription / Resource group:** your lab subscription and `rg-sc500-lab`
3. On the **Resources** step, select your test Windows VM
4. On the **Collect and deliver** step, choose an event set such as:
   - **Common** for a balanced security-focused set, or
   - **All events** only if you intentionally want more data volume
5. Send the events to `law-sc500-sentinel`
6. Create the DCR

### Step 3.3 - Confirm AMA installation

1. Open the VM in Azure
2. Check **Extensions + applications**
3. Confirm the **Azure Monitor Agent** is installed

---

## Part 4: Validate data arrival

### Step 4.1 - Generate a small amount of security activity

On the Windows VM, generate a few basic events such as:

- A successful sign-in
- A failed sign-in
- Starting a process such as PowerShell or Command Prompt

### Step 4.2 - Query the SecurityEvent table

In Sentinel or Log Analytics, run:

```kql
SecurityEvent
| where TimeGenerated > ago(30m)
| where Computer has "vm-"
| summarize EventCount = count() by EventID, Computer
| order by EventCount desc
```

### Step 4.3 - Inspect a higher-signal event

```kql
SecurityEvent
| where TimeGenerated > ago(30m)
| where EventID in (4624, 4625, 4688)
| project TimeGenerated, Computer, EventID, Account, Activity, ProcessName, IpAddress
| order by TimeGenerated desc
```

Expected result: events appear in the `SecurityEvent` table after ingestion begins.

---

## Part 5: Compare to Syslog, CEF, and custom logs

Record the differences in your notes:

- **Syslog via AMA** = Linux and network-device style events into the `Syslog` table
- **CEF via AMA** = security appliances sending normalized events into `CommonSecurityLog`
- **Windows Security Events via AMA** = Windows event logs into `SecurityEvent`
- **Custom logs** = file-based or custom-schema data when a built-in connector does not fit

> If the exam asks which path is best for firewall, IDS, or appliance logs, think **Syslog** or **CEF** rather than Windows Security Events.

---

## Validation Steps

Confirm all of the following:

- You can explain what Content hub installs and what it does not
- A DCR is attached to your test source
- AMA is installed on the selected VM
- Windows security events appear in `SecurityEvent`
- You can explain when to use `SecurityEvent`, `Syslog`, `CommonSecurityLog`, and a custom log table

---

## Exam traps

- **Content hub** installs packaged Sentinel content; it does not replace DCR configuration for agent-based collection
- **DCR** controls collection and delivery for AMA-based ingestion
- **Syslog** and **CEF** are not the same as Windows Security Events
- **Custom logs** are for unsupported or special-case sources, not your first choice when a built-in connector exists

---

## Cleanup Instructions

1. Remove the DCR association or delete the DCR if you no longer need the source
2. Uninstall AMA from the VM if it was deployed only for this lab
3. Remove any solution you installed from Content hub if you do not plan to use it later
4. Keep the workspace if you are continuing with the later Sentinel labs

---

## References

- <https://learn.microsoft.com/en-us/azure/sentinel/data-transformation>
- <https://learn.microsoft.com/en-us/azure/sentinel/connect-windows-security-events>
- <https://learn.microsoft.com/en-us/azure/sentinel/connect-cef-syslog-ama>
- <https://learn.microsoft.com/en-us/azure/sentinel/sentinel-solutions-deploy>
