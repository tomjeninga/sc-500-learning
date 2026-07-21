# Lab 06: Logic Apps Security for Sentinel Playbooks

## Overview

**Estimated Time:** 45-60 minutes  
**Estimated Cost:** Low, plus any Logic Apps execution charges from testing  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will secure a Sentinel playbook by enabling a managed identity, granting only
the minimum Sentinel role it needs, reviewing connector permissions, and
validating that the playbook still works without broad standing access.

**Why this matters for SC-500:**
- Logic Apps are part of the application platform surface measured on the exam
- Sentinel playbooks are powerful, but they also become privileged automation identities
- Many candidates know how to build a playbook but not how to secure its identity and permissions

**Architecture:**

```text
Sentinel incident
      |
      v
Automation rule triggers playbook
      |
      v
[Logic App playbook]
      |
      +--> System-assigned managed identity
      +--> Sentinel Reader or Responder role
      +--> Only required connectors enabled
```

---

> **Depends on:** `03-security-operations/lab-05-sentinel-automation-playbooks.md` or another existing Sentinel playbook
> **Reused by:** no required follow-up lab; this is usually the final hardening step for the Sentinel automation chain
> **Delete after:** you no longer need the playbook or its managed identity permissions

## Prerequisites

- A Sentinel playbook already exists
- Permissions to modify the Logic App and assign roles on the Sentinel workspace
- Owner or User Access Administrator if you need to create workspace role assignments

---

## Part 1: Review the playbook trust model

Before making changes, make sure you can explain these separate permission layers:

| Identity or principal | Why it matters |
| --- | --- |
| Microsoft Sentinel service | Needs permission to trigger the playbook |
| Logic App managed identity | Needs permission to read or update Sentinel data |
| External connectors | May require separate auth and can expand blast radius |

**Memorize this rule:**
- Sentinel needs permission to **run** the playbook
- The playbook identity needs permission to **do** the work

---

## Part 2: Enable a managed identity on the playbook

### Step 2.1 - Turn on system-assigned identity

1. Open the Logic App resource used by your playbook
2. Go to **Identity**
3. Enable **System assigned** managed identity
4. Save

### Step 2.2 - Record the principal ID

Note the managed identity's object or principal ID for later review.

---

## Part 3: Grant only the required Sentinel role

### Step 3.1 - Decide the minimum role

Use this rule of thumb:

- **Microsoft Sentinel Reader** if the playbook only reads incidents or entities
- **Microsoft Sentinel Responder** if the playbook updates incidents, tags, or comments

### Step 3.2 - Assign the role

1. Open the Sentinel workspace resource
2. Go to **Access control (IAM)**
3. Add role assignment:
   - **Role:** `Microsoft Sentinel Reader` or `Microsoft Sentinel Responder`
   - **Assign access to:** `Logic App`
   - **Select:** your playbook

> Avoid using Owner or Contributor on the whole resource group when a Sentinel-specific role is enough.

---

## Part 4: Review connector and secret usage

### Step 4.1 - Inspect connectors

Open the playbook designer and review every connector in the workflow.

Ask:

- Does this connector need a user-based connection, or can it use managed identity?
- Is the connector reaching a system the playbook does not truly need?
- Is a broad personal account authorizing the workflow when a service identity would be better?

### Step 4.2 - Remove unnecessary privilege

For the lab:

1. Remove any unused connector actions
2. Prefer Sentinel actions that use the managed identity path where supported
3. If a secret is needed for a non-Microsoft system, document that it should live in Key Vault rather than in plain text

---

## Part 5: Validate secure operation

### Step 5.1 - Rerun the workflow

Trigger the playbook again from a test incident or rerun it manually.

### Step 5.2 - Confirm least-privilege still works

Verify:

- The playbook still completes successfully
- It can update only what its role allows
- There are no failures caused by over-tightening the required Sentinel role

### Step 5.3 - Review run history and health

Inspect the Logic App run history and, if available, Sentinel automation health indicators for permission issues.

---

## Validation Steps

Confirm all of the following:

- The Logic App uses a system-assigned managed identity
- The managed identity has only the minimum Sentinel role it needs
- Unused or overly broad connectors were removed or documented
- The playbook still runs successfully after the permission change

---

## Exam traps

- **Sentinel Automation Contributor** lets Sentinel trigger a playbook; it is not the role the playbook uses to act on the workspace
- **Managed identity** is usually better than a broad user connection for playbook access
- **Contributor** on a resource group is often more permission than a playbook needs
- Securing a playbook means securing both its **trigger path** and its **action identity**

---

## Cleanup Instructions

1. Remove the managed identity role assignment if the playbook is deleted
2. Delete the playbook if it was created only for the lab
3. Remove any unused API connections or test notifications

---

## References

- <https://learn.microsoft.com/en-us/azure/sentinel/automation/authenticate-playbooks-to-sentinel>
- <https://learn.microsoft.com/en-us/azure/sentinel/automation/automate-responses-with-playbooks>
- <https://learn.microsoft.com/en-us/azure/logic-apps/create-managed-service-identity>
