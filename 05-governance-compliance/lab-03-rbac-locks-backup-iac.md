# Lab 03: Governance Controls with RBAC, Resource Locks, Backup Security, and IaC

## SC-500 Skill Mapping

This lab maps to SC-500 governance objectives around:

- Managing Azure built-in role assignments
- Managing custom roles in Azure RBAC
- Evaluating and remediating overprivileged access with Azure RBAC
- Implementing resource locks
- Configuring backup protection with Azure Backup security features
- Implementing security controls with Infrastructure as Code

---

## Learning Objectives

After completing this lab, you will be able to:

- Review role assignments at the right scope and identify overprivileged access
- Create or evaluate a narrowly scoped custom role
- Apply a resource lock and explain lock inheritance and control-plane limits
- Review Azure Backup security settings such as immutability, soft delete, and multi-user authorization
- Explain how locks and RBAC controls should be represented in IaC

---

## Prerequisites

- Azure subscription with `rg-sc500-lab`
- Owner or User Access Administrator for RBAC and resource lock changes
- Optional existing Recovery Services vault or Backup vault, or permission to create a small vault for review
- Recommended: `lab-01-azure-policy.md` first, so governance scope and effect concepts are already familiar

---

## Architecture (in words)

Governance lives above individual workloads. Azure RBAC controls who can act, custom roles narrow what they can do, resource locks prevent accidental control-plane deletion, and Azure Backup security features protect recovery points from tampering. IaC makes those controls repeatable instead of one-off portal changes.

```text
Azure subscription / resource group
        |
        +--> Azure RBAC role assignments
        +--> Optional custom role definition
        +--> Resource locks
        \--> Recovery Services vault / Backup vault
                 +--> soft delete / immutability
                 +--> multi-user authorization

Governance-as-code
        \--> Bicep / ARM / JSON definitions for repeatable controls
```

---

> **Depends on:** `05-governance-compliance/lab-01-azure-policy.md` for the policy-first governance baseline
> **Reused by:** `05-governance-compliance/lab-02-compliance-assessment.md` conceptually, because compliance dashboards are stronger when you already understand the underlying governance controls
> **Delete after:** you finish role, lock, and backup-security validation and no longer need any temporary vault or test assignments

## Part 1: Review Azure RBAC for overprivileged access

### Step 1.1 - Inspect assignments at scope

1. Open the Azure portal
2. Go to the target scope such as the subscription or `rg-sc500-lab`
3. Open **Access control (IAM)** -> **Role assignments**
4. Review:
   - Users or groups with **Owner** or **Contributor**
   - Inherited assignments
   - Permanent vs eligible assignments if your tenant exposes that view

### Step 1.2 - Check a specific principal

1. Open **Check access**
2. Select a user, group, or managed identity
3. Record:
   - Direct assignments
   - Inherited assignments
   - Whether the principal has more access than the task requires

### Step 1.3 - Use the privileged view if available

If your tenant exposes the **Privileged** tab, review privileged role assignments at the current scope and note which ones should be narrowed, removed, or moved into PIM.

> **Why this control, not the distractor:** Azure RBAC answers who can manage Azure resources. Conditional Access does not fix an over-broad `Owner` assignment.

---

## Part 2: Create or review a custom role

### Step 2.1 - Pick a narrow use case

Use a task that does not justify Contributor. Example: start and restart virtual machines, but not create or delete them.

### Step 2.2 - Create the role definition

In the portal or JSON, define a role that includes only the required actions.

Example JSON shape:

```json
{
  "Name": "SC500 VM Operator",
  "Description": "Can read, start, and restart VMs without broad write access.",
  "Actions": [
    "Microsoft.Compute/virtualMachines/read",
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/restart/action",
    "Microsoft.Resources/subscriptions/resourceGroups/read"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/<subscription-id>"
  ]
}
```

### Step 2.3 - Assign and compare

1. Assign the custom role to a test user or group at the smallest practical scope
2. Compare it to **Contributor**
3. Record why the custom role is safer

> Prefer explicit actions over broad wildcards where possible.

---

## Part 3: Apply a resource lock

### Step 3.1 - Create a lock

1. Open `rg-sc500-lab` or one lab resource such as the storage account
2. Open **Locks**
3. Add a **Delete** (`CanNotDelete`) lock named `sc500-protect-delete`

### Step 3.2 - Test the effect

1. Attempt to delete the protected resource or resource group
2. Confirm Azure blocks the deletion

### Step 3.3 - Record the boundary

Write down the key distinction:

- Locks protect **control-plane** operations
- Locks do **not** automatically protect **data-plane** operations inside the service

Important examples to remember:

- A storage account lock does not automatically protect blob data deleted through data-plane operations
- Locks can have side effects on some platform operations
- A `CanNotDelete` lock on the Azure Backup service-created resource group can cause backup failures because cleanup of restore points is blocked

---

## Part 4: Review Azure Backup security features

### Step 4.1 - Create or open a vault

1. Open an existing **Recovery Services vault** or **Backup vault**, or create a small lab vault
2. Review the vault security settings

### Step 4.2 - Inspect the core protections

Look for and explain these controls:

- **Soft delete** or **enhanced soft delete**
- **Immutability**
- **Multi-user authorization (MUA)** with **Resource Guard**
- Backup-specific Azure RBAC roles such as:
  - `Backup Contributor`
  - `Backup Operator`
  - `Backup Reader`

### Step 4.3 - Record the security model

Use this summary table:

| Control | Why it matters |
| --- | --- |
| Soft delete | Recovers from accidental or malicious deletion |
| Immutability | Prevents backup tampering or early deletion |
| MUA / Resource Guard | Adds approval protection for critical vault operations |
| Backup RBAC roles | Segregates backup administration duties |

> **Exam tip:** Backup security is not just “turn on backup.” The exam often cares about immutability, MUA, and separation of duties.

---

## Part 5: Represent governance in IaC

### Step 5.1 - Review a lock in Bicep

Use this example to show how a lock can be versioned as code:

```bicep
resource rgLock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'sc500-delete-lock'
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevents accidental deletion of the lab resource group.'
  }
}
```

### Step 5.2 - Record the governance principle

If a control matters for many environments, it should not live only in the portal. Track role definitions, policy definitions, locks, and vault standards in versioned IaC wherever possible.

---

## Validate

Confirm all of the following:

- You reviewed Azure RBAC assignments at the correct scope
- You identified at least one overprivileged pattern or explained why none were present
- You created or reviewed a custom role that is narrower than Contributor
- A resource lock blocked a delete operation as expected
- You can explain why locks apply to the control plane and not automatically to the data plane
- You reviewed Azure Backup security settings and can explain immutability, soft delete, and MUA

---

## Exam Traps

- **Resource locks** are not the same as **RBAC**; locks override user permissions for protected operations
- **Locks** protect the **control plane**, not every data operation inside a service
- **Contributor** is often too broad when a **custom role** or built-in narrower role would work
- **Azure Backup** security questions often hinge on **immutability**, **soft delete**, or **Resource Guard / MUA**, not just backup schedules
- A badly placed lock can break service behavior, including some Azure Backup cleanup operations

---

## Cleanup

1. Remove the test custom role assignment if it was created only for this lab
2. Delete the custom role if it is no longer needed
3. Remove the resource lock if it blocks later lab cleanup
4. Delete the temporary vault only if it was created only for this exercise

---

## References

- <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources>
- <https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles>
- <https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-list-portal>
- <https://learn.microsoft.com/en-us/azure/backup/security-overview>
