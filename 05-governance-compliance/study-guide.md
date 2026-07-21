# Module 5 Study Guide: Governance & Compliance

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Azure Policy definitions, initiatives, and assignments
- All seven policy effects and when each is used
- Management Groups: hierarchy, policy inheritance, RBAC delegation
- Azure landing zones and governance at scale
- Regulatory Compliance dashboard in Defender for Cloud
- Common compliance frameworks: ISO 27001, SOC 2, CIS Benchmarks, NIST SP 800-53, PCI-DSS, HIPAA

---

## 1. Azure Policy

### What is Azure Policy?

Azure Policy evaluates resources against defined rules and enforces organizational standards. It answers: **"Are my Azure resources compliant with my rules?"**

> **Real-world context for platform engineers:** Your organization mandates that all Azure resources must have a `CostCenter` tag. Azure Policy can enforce this — either by auditing non-compliant resources (Audit effect) or by blocking creation of resources without the tag (Deny effect). Combined with remediation tasks, you can automatically tag existing resources (Modify/DeployIfNotExists effects).

### Policy Components

| Component | Description |
|-----------|-------------|
| **Policy definition** | The rule itself — conditions to evaluate + effect to apply |
| **Initiative (policy set)** | A collection of policy definitions to achieve a compliance goal |
| **Assignment** | Binding a definition or initiative to a scope (subscription, RG, MG) |
| **Compliance** | The result — which resources pass or fail the assignment |
| **Remediation task** | Automated fix for non-compliant resources (for DeployIfNotExists/Modify effects) |
| **Exemption** | Exclude specific resources from evaluation |

### Policy Scope

```
Management Group
  └── Subscription
        └── Resource Group
              └── Resource
```

Policies assigned at a higher scope apply to all resources at lower scopes.

---

## 2. Policy Effects

Effects determine what happens when the policy conditions are met:

| Effect | Action | Example Use Case |
|--------|--------|-----------------|
| **Deny** | Block the CREATE/UPDATE operation | Prevent storage accounts without HTTPS |
| **Audit** | Allow but create a compliance finding | Log VMs not using managed disks |
| **AuditIfNotExists** | Audit if a related resource doesn't exist | Audit VMs without Defender extension |
| **DeployIfNotExists** | Deploy a related resource if it doesn't exist | Auto-deploy Azure Monitor Agent or another required extension on VMs |
| **Modify** | Change tags or properties during create/update | Auto-add environment tag during resource creation |
| **Append** | Add fields to a resource during create/update | Append a required property to storage accounts |
| **Disabled** | No action (used to disable a policy in an initiative) | — |

### Effect Priority Order

When multiple policies apply to a resource:
```
Disabled → Append → Deny → Audit/AuditIfNotExists → DeployIfNotExists → Modify
```

> **Exam tip:** Deny is evaluated before Audit. If a resource fails a Deny policy, it is blocked — Audit effects for the same condition don't matter.

### Deny vs Audit Decision

| Question | Answer |
|----------|--------|
| "Log non-compliant resources" | Use **Audit** |
| "Block non-compliant resources" | Use **Deny** |
| "Fix automatically on create" | Use **DeployIfNotExists** or **Modify** |
| "Fix existing non-compliant resources" | Create a **Remediation task** |

---

## 3. Policy Definitions

### Structure of a Policy Definition

```json
{
  "properties": {
    "displayName": "Require tag and value on resources",
    "description": "Enforces a required tag and its value.",
    "mode": "Indexed",
    "policyRule": {
      "if": {
        "field": "[concat('tags[', parameters('tagName'), ']')]",
        "exists": "false"
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    },
    "parameters": {
      "tagName": {
        "type": "String",
        "metadata": { "displayName": "Tag Name" }
      },
      "effect": {
        "type": "String",
        "allowedValues": ["Deny", "Audit", "Disabled"]
      }
    }
  }
}
```

### Built-In vs Custom Policies

| | Built-In | Custom |
|-|---------|--------|
| Created by | Microsoft | You |
| Available scope | All subscriptions | Your tenant/MG/subscription |
| Examples | "Require TLS 1.2 for storage", "Allowed locations" | "Require CostCenter tag", company-specific rules |
| Count | Thousands | As many as you create |

### Key Built-In Policies for SC-500

| Policy | Effect |
|--------|--------|
| "Require secure transfer to storage accounts" | Deny |
| "Ensure SSL connection is enabled for PostgreSQL" | Audit |
| "Deploy Azure Monitor Agent to Windows VMs" | DeployIfNotExists |
| "Allowed locations" | Deny |
| "Inherit a tag from the resource group" | Modify |
| "Add a tag to resources" | Modify |

---

## 4. Initiatives (Policy Sets)

An initiative groups related policies to achieve a broader compliance goal.

**Example: CIS Microsoft Azure Foundations Benchmark initiative**
- Contains 100+ individual policies
- Each maps to a CIS control
- Assigned at subscription level
- Generates compliance score

**Microsoft provides pre-built regulatory compliance initiatives for:**
- CIS Microsoft Azure Foundations Benchmark
- ISO 27001:2013
- NIST SP 800-53
- PCI DSS v3.2.1
- HIPAA/HITRUST
- SOC 2 Type II
- FedRAMP High

---

## 5. Management Groups

### What are Management Groups?

Management Groups are containers above subscriptions that let you:
- Apply policies across multiple subscriptions at once
- Delegate RBAC at a higher scope
- Organize subscriptions by business unit, environment, or geography

### Default Hierarchy

```
Tenant Root Group (automatically created)
├── Management Group: Corp
│   ├── Management Group: Production
│   │   ├── Subscription: Sub-Prod-1
│   │   └── Subscription: Sub-Prod-2
│   └── Management Group: Dev-Test
│       └── Subscription: Sub-DevTest-1
└── Management Group: Sandbox
    └── Subscription: Sub-Sandbox-1
```

### Policy Inheritance

A policy assigned to `Corp` management group:
- Applies to all child management groups (Production, Dev-Test)
- Applies to all subscriptions within those groups
- Applies to all resource groups and resources in those subscriptions

### Azure Landing Zones

The Azure Landing Zone (ALZ) architecture uses Management Groups to provide:
- Consistent governance across subscriptions
- Pre-configured policy initiatives (security, networking, identity)
- Platform management subscriptions (hub, identity, management)
- Application landing zone subscriptions

---

## 6. Regulatory Compliance Dashboard

### Overview

The Defender for Cloud Regulatory Compliance dashboard shows how your environment maps to compliance frameworks.

**How it works:**
1. You enable a compliance standard (initiative) in Defender for Cloud
2. Azure Policy evaluates your resources against the controls
3. The dashboard shows pass/fail for each control
4. You drill into failing controls to see which resources need remediation

### Enabling a Compliance Standard

1. Defender for Cloud → **Regulatory compliance**
2. Click **Manage compliance policies**
3. Select your subscription
4. Under **Azure Policy Add-ons**, find the standard (e.g., PCI-DSS)
5. Toggle to **On**

### Reading the Dashboard

| Column | Description |
|--------|-------------|
| **Control** | Compliance control (e.g., "1.1 Implement a security policy") |
| **Passing resources** | Resources compliant with this control |
| **Failing resources** | Resources not meeting the control |
| **N/A** | Resources not applicable to this control |
| **% compliance** | (Passing) / (Passing + Failing) |

---

## 7. Common Compliance Frameworks

| Framework | Relevant For | Key SC-500 Relevance |
|-----------|-------------|---------------------|
| **ISO 27001:2013** | International general security standard | Broad information security controls |
| **SOC 2 Type II** | Service organizations storing customer data | Trust service criteria (Security, Availability, etc.) |
| **CIS Benchmarks** | Technical hardening guidelines | Specific configuration checks for Azure resources |
| **NIST SP 800-53** | US federal agencies, contractors | Extensive control catalog |
| **PCI-DSS** | Payment card data handling | Specific requirements for cardholder data environments |
| **HIPAA** | US healthcare data (ePHI) | Patient data privacy and security requirements |

> **Exam tip:** You won't be tested on memorizing individual control numbers. You WILL be tested on which framework applies to which industry and how to assign/review it in Defender for Cloud.

---

## Comparison: Policy Effects

| Scenario | Recommended Effect |
|----------|-------------------|
| Block resource creation if non-compliant | **Deny** |
| Report non-compliant resources without blocking | **Audit** |
| Report when a required resource doesn't exist | **AuditIfNotExists** |
| Automatically create a required resource | **DeployIfNotExists** |
| Add/modify a tag or property on new resources | **Modify** |
| Disable a policy in an initiative | **Disabled** |

---

## 8. Resource Locks

Resource locks protect Azure resources from accidental control-plane deletion or modification.

| Lock type | What it does |
|----------|---------------|
| **CanNotDelete** | Resource can be modified but not deleted |
| **ReadOnly** | Resource can be read but not modified or deleted |

### Key distinctions

- Locks apply to the **control plane**, not automatically to the **data plane**
- Locks are inherited from parent scope to child scope
- The most restrictive inherited lock wins

> **Exam tip:** A lock on a storage account does not automatically protect blob data deleted through data-plane operations.

### Important side effects

- Locks can block legitimate management operations that use POST behind the scenes
- A badly placed lock can interfere with platform features
- A `CanNotDelete` lock on the Azure Backup service-created resource group can cause backup failures because Azure Backup cannot clean up restore points

---

## 9. Azure RBAC Least Privilege and Custom Roles

Azure RBAC governance questions often test whether you can narrow access instead of defaulting to **Owner** or **Contributor**.

### Review model

When reviewing access, ask:

1. Is the assignment at the correct scope?
2. Is it inherited when it should be direct, or direct when it should be inherited?
3. Does a built-in role already fit?
4. If not, is a custom role justified?

### Custom roles

Use custom roles when built-in roles are too broad and the task is well-defined.

Key properties:

- `Actions`
- `NotActions`
- `DataActions`
- `AssignableScopes`

> **Exam tip:** Prefer explicit actions over broad wildcards unless there is a strong reason to accept future permission expansion.

### Overprivileged access patterns

Common risks include:

- Too many permanent **Owner** assignments
- Contributor used where a narrower built-in or custom role would work
- Managed identities with broad subscription-level access
- Privileged assignments left active instead of governed through PIM

---

## 10. Azure Backup Security Features

For SC-500, backup security is not only about retention. It is also about protecting recovery points from deletion or tampering.

| Control | Why it matters |
|---------|----------------|
| **Soft delete / enhanced soft delete** | Recovers from accidental or malicious deletion |
| **Immutability** | Prevents backup data from being altered or deleted early |
| **Multi-user authorization (MUA)** | Adds approval protection for critical vault operations |
| **Resource Guard** | Enforces the second layer used by MUA |
| **Backup RBAC roles** | Separates backup administration duties |

### Backup RBAC roles to know

- **Backup Contributor**
- **Backup Operator**
- **Backup Reader**

### Security posture thinking

The strongest vault posture usually combines:

- locked or always-on soft delete
- immutability
- MUA with Resource Guard
- least-privilege backup roles

---

## 11. Governance as Code

Governance controls should be repeatable.

Common examples:

- Azure Policy definitions and assignments
- Resource locks in ARM or Bicep
- Custom role definitions stored as JSON
- Vault or monitoring standards embedded in deployment pipelines

**Why this matters:**
If the control matters for every environment, the portal should not be the only place it exists.

---

## Self-Check Questions

1. What is the difference between a policy **definition** and a policy **assignment**?

2. You want to ensure all new VMs in your subscription are deployed with disk encryption enabled. Which policy effect would you use to enforce this, and what alternative effect would only log violations?

3. A resource has been created without the required `CostCenter` tag. A `Modify` policy is assigned to add the tag, but the resource was created before the policy was assigned. What must you do to fix the existing resource?

4. How does policy assignment at the Management Group level affect subscriptions that are members of that group?

5. What is the difference between a **policy set (initiative)** and an individual policy definition?

6. A SOC analyst asks you to prove that your Azure environment meets ISO 27001 requirements. What Defender for Cloud feature do you use?

7. What is the purpose of the **AuditIfNotExists** effect and give an example of where it's used?

8. What is the difference between a `CanNotDelete` lock and a `ReadOnly` lock?

9. Why does a resource lock not automatically protect all data inside a storage account?

10. When is a custom role a better answer than Contributor?

11. Which Azure Backup features best protect recovery points from ransomware-driven deletion?

---

## Microsoft Learn Resources

- [Implement and manage enforcement of cloud governance policies](https://learn.microsoft.com/en-us/training/modules/implement-manage-enforcement-cloud-governance-policies/)
- [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)
- [Management Group overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard)
- [Lock your Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Azure Backup security overview](https://learn.microsoft.com/en-us/azure/backup/security-overview)
