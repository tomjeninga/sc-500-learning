# Lab 05: Sentinel Automation Rules and Playbooks

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$1-3 plus Logic Apps execution charges if heavily tested  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create a Microsoft Sentinel playbook backed by Azure Logic Apps,
create an automation rule that runs it when an incident is created, and validate
the difference between analytics rules, automation rules, and playbooks.

**Why this matters for SC-500:**
- Microsoft Sentinel is tested as both **SIEM** and **SOAR**
- Candidates often mix up **analytics rules**, **automation rules**, and **playbooks**
- Sentinel automation is one of the fastest ways to turn a detection into repeatable response

**Architecture:**

```text
Analytics rule
    |
    v
Sentinel incident
    |
    v
Automation rule
    |
    v
Logic App playbook
    |
    +--> Add tag or comment to incident
    +--> Notify analyst / team
```

---

> **Depends on:** `03-security-operations/lab-02-sentinel-setup.md` and ideally `03-security-operations/lab-03-sentinel-triage-investigation.md` so you already have a rule or incident to test
> **Reused by:** `03-security-operations/lab-06-logic-apps-security-for-playbooks.md`
> **Delete after:** you finish automation testing and no longer need the playbook or automation rule in the workspace

## Prerequisites

- `law-sc500-sentinel` exists and is generating incidents or can generate a test incident
- Owner or User Access Administrator on the resource group where the playbook will live
- Logic App creation permissions
- Optional: Microsoft 365 or Teams permissions if you choose a notification action

---

## Part 1: Review the automation layers

Before building, make sure you can explain this chain:

| Layer | Purpose |
| --- | --- |
| Analytics rule | Detects suspicious behavior and creates alerts or incidents |
| Automation rule | Decides when and under what conditions to run follow-up actions |
| Playbook | Executes workflow steps by using Azure Logic Apps |

**Memorize this rule:**
- Detection happens in the **analytics rule**
- Orchestration logic starts in the **automation rule**
- Response actions happen in the **playbook**

---

## Part 2: Create a simple playbook

### Step 2.1 - Create the playbook

1. In Sentinel, open **Automation** -> **Playbooks** or **Active playbooks**
2. Create a new playbook based on **Logic Apps**
3. Use a Sentinel trigger such as:
   - **When a response to a Microsoft Sentinel incident is triggered**, or
   - **Microsoft Sentinel incident** trigger depending on the experience in your portal
4. Name it `la-sc500-incident-tagger`

### Step 2.2 - Add simple actions

Keep the workflow minimal for the lab:

1. Add a Microsoft Sentinel action to:
   - Add a comment to the incident, or
   - Add a tag such as `sc500-auto-reviewed`
2. Optionally add a second action such as:
   - Send an email
   - Post a Teams message
   - Create a task or ticket stub

### Step 2.3 - Save the playbook

Save the Logic App and confirm it appears in Sentinel's playbook list.

---

## Part 3: Grant Sentinel permission to run the playbook

### Step 3.1 - Assign the Sentinel automation role

1. Open the resource group that contains the playbook
2. Go to **Access control (IAM)**
3. Add role assignment:
   - **Role:** `Microsoft Sentinel Automation Contributor`
   - **Member:** the Microsoft Sentinel service for your workspace as exposed in the portal flow

> This permission is for Sentinel to trigger the playbook. It is separate from the permissions the playbook itself might need.

---

## Part 4: Create an automation rule

### Step 4.1 - Create the rule

1. In Sentinel, open **Automation** -> **Create** -> **Automation rule**
2. Configure:
   - **Name:** `sc500-high-severity-incident-automation`
   - **Trigger:** `When incident is created`
3. Add conditions such as:
   - **Severity** equals `High`, or
   - **Analytics rule name** equals your test rule from Lab 02

### Step 4.2 - Add actions

Add one or more actions:

- Add a tag such as `auto-processed`
- Assign the incident to a specific analyst if appropriate
- Run the playbook `la-sc500-incident-tagger`

Save the automation rule.

---

## Part 5: Trigger and validate the workflow

### Step 5.1 - Generate or reuse a test incident

Use one of these approaches:

- Trigger the scheduled analytics rule from Lab 02
- Reuse a safe test incident from Lab 03
- Manually run the playbook on an incident if needed for first validation

### Step 5.2 - Verify the automation result

Check:

- The incident received the expected tag or comment
- The playbook run shows **Succeeded** in Logic Apps run history
- The automation rule appears in the incident history or audit trail

---

## Validation Steps

Confirm all of the following:

- You can explain the difference between analytics rules, automation rules, and playbooks
- Sentinel has permission to trigger the playbook
- A new or selected incident causes the automation rule to fire
- The playbook successfully updates the incident or sends the selected notification

---

## Exam traps

- **Analytics rules** detect; they do not replace playbooks
- **Automation rules** coordinate response; they do not perform complex integrations by themselves
- **Playbooks** are built on **Azure Logic Apps**, not on KQL or workbooks
- The permission for **Sentinel to run a playbook** is separate from the permission the **playbook uses to act on resources**

---

## Cleanup Instructions

1. Disable or delete the automation rule if it is no longer needed
2. Disable or delete the playbook if it was created only for the lab
3. Remove any low-value test comments or tags on incidents

---

## References

- <https://learn.microsoft.com/en-us/azure/sentinel/automation/automation>
- <https://learn.microsoft.com/en-us/azure/sentinel/automation/create-playbooks>
- <https://learn.microsoft.com/en-us/azure/sentinel/automation/run-playbooks>
