# Lab 01: Azure Policy — Custom Deny Policy and Remediation

## Overview

**Estimated Time:** 45–60 minutes  
**Estimated Cost:** $0 (Azure Policy is free)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will assign a built-in audit policy, create a custom deny policy that requires a `CostCenter` tag on all resources, test enforcement by attempting to create an untagged resource, and create a remediation task for existing non-compliant resources.

**Why this matters:**
- Azure Policy is a core governance tool tested on SC-500
- Policy effects (Deny, Audit, DeployIfNotExists, Modify) are directly examined
- Remediation tasks are often the correct answer when asked about fixing existing resources

> **Depends on:** no earlier governance lab is required; this is the best Module 5 starting point
> **Reused by:** `05-governance-compliance/lab-03-rbac-locks-backup-iac.md` and `05-governance-compliance/lab-02-compliance-assessment.md`
> **Delete after:** you finish the later governance labs that reuse the policy context or compliance evidence

---

## Prerequisites

- `rg-sc500-lab` resource group
- Owner or Policy Contributor role on the resource group/subscription

---

## Part 1: Assign a Built-In Audit Policy

### Step 1.1 — Navigate to Policy

1. In Azure Portal, search for **Policy** → click **Policy**
2. In the left menu, click **Assignments**
3. Click **+ Assign policy**

### Step 1.2 — Configure the assignment

4. **Scope:** Click the `...` button → select your subscription → select `rg-sc500-lab` → click **Select**
5. **Policy definition:** Click the `...` button
6. Search for `"Secure transfer to storage accounts should be enabled"`
7. Click the policy → **Select**
8. **Assignment name:** `Audit - Storage Secure Transfer`
9. **Policy enforcement:** Enabled
10. Click **Review + create** → **Create**

### Step 1.3 — Verify compliance

After a few minutes:
1. Go to Policy → **Compliance**
2. Find your assignment
3. ✅ Any storage accounts without secure transfer will appear as non-compliant

---

## Part 2: Create a Custom Deny Policy

### Step 2.1 — Create the policy definition

1. In Policy → **Definitions** → **+ Policy definition**
2. **Definition location:** Select your subscription
3. **Name:** `Require CostCenter tag on resources`
4. **Description:** Denies creation of any resource without a CostCenter tag.
5. **Category:** Create new: `SC500-Lab`
6. **Policy rule:** Replace the default rule with:

```json
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "notIn": [
          "Microsoft.Resources/resourceGroups",
          "Microsoft.Resources/deployments",
          "Microsoft.Authorization/policyAssignments",
          "Microsoft.Authorization/roleAssignments"
        ]
      },
      {
        "field": "tags['CostCenter']",
        "exists": false
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]"
  }
}
```

7. **Parameters:** Add a parameter:

```json
{
  "effect": {
    "type": "String",
    "defaultValue": "Deny",
    "allowedValues": ["Deny", "Audit", "Disabled"],
    "metadata": {
      "displayName": "Effect",
      "description": "Deny, Audit, or Disabled"
    }
  }
}
```

8. Click **Save**

### Step 2.2 — Assign the custom policy

1. Go to Policy → **Assignments** → **+ Assign policy**
2. **Scope:** `rg-sc500-lab`
3. **Policy definition:** Search for `Require CostCenter tag on resources`
4. **Assignment name:** `Deny - Require CostCenter Tag`
5. **Parameters tab:** Set Effect = **Deny**
6. **Non-compliance message:** "All resources must have a CostCenter tag."
7. Click **Review + create** → **Create**

---

## Part 3: Test Policy Enforcement

### Step 3.1 — Attempt to create a resource without the tag

Try to create a storage account without a `CostCenter` tag:

1. Search for **Storage accounts** → **+ Create**
2. Fill in the basics (any name, East US, `rg-sc500-lab`)
3. Click **Review + create** → **Create**
4. ✅ **Expected result:** Creation fails with a policy violation error:
   > "Resource 'storagetest' was disallowed by policy 'Deny - Require CostCenter Tag'"

### Step 3.2 — Create resource WITH the required tag

1. Repeat the storage account creation
2. In the **Tags** tab, add:
   - **Name:** `CostCenter`
   - **Value:** `Learning`
3. Click **Review + create** → **Create**
4. ✅ **Expected result:** Resource is created successfully

---

## Part 4: Remediation Task

### Step 4.1 — Create an Audit policy for missing tags

Policy Deny blocks new resources, but existing resources also need remediation. For existing resources, use **Audit** + **Remediation task**.

1. Create a new policy assignment:
   - Scope: `rg-sc500-lab`
   - Policy: Built-in `Add a tag to resources`
   - Parameters:
     - Tag Name: `Environment`
     - Tag Value: `Lab`
   - Effect: Modify

### Step 4.2 — Run a remediation task

2. Go to Policy → **Remediation**
3. Find your `Add a tag to resources` assignment
4. Click **+ New remediation task**
5. Configure:
   - **Policy to remediate:** Your assignment
   - **Scope:** `rg-sc500-lab`
   - **Locations:** All locations
6. Click **Remediate**

### Step 4.3 — Monitor remediation progress

7. Click on the remediation task
8. Watch the remediation status:
   - Deploying
   - Succeeded
9. ✅ Resources in `rg-sc500-lab` should now have the `Environment: Lab` tag

---

## ARM Template Deployment

```bash
# Deploy the custom policy definition via ARM
az deployment sub create \
  --location eastus \
  --template-file templates/azure-policy-definitions.json \
  --parameters policyEffect=Deny
```

```powershell
New-AzDeployment `
  -Location "eastus" `
  -TemplateFile ".\templates\azure-policy-definitions.json" `
  -policyEffect "Deny"
```

---

## Validation Steps

```powershell
# List policy assignments on the resource group
Get-AzPolicyAssignment -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)/resourceGroups/rg-sc500-lab" |
    Select-Object Name, @{N="Policy";E={$_.Properties.DisplayName}}, @{N="Effect";E={$_.Properties.Parameters.effect.value}} |
    Format-Table

# Check compliance state
Get-AzPolicyState -ResourceGroupName "rg-sc500-lab" -Top 10 |
    Select-Object ResourceId, ComplianceState, PolicyDefinitionName |
    Format-Table
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Policy not enforcing immediately | Propagation delay (~30 min) | Wait 30 minutes; use "-EnforcementMode Default" |
| Remediation task fails | Missing permissions | Policy managed identity needs Contributor role on scope |
| Cannot create policy definition | Missing permissions | Need Policy Contributor or Owner |
| Built-in policy not found | Search term too broad | Use exact name or filter by category |

---

## Cleanup Instructions

```powershell
$scope = "/subscriptions/$($(Get-AzContext).Subscription.Id)/resourceGroups/rg-sc500-lab"

# Remove policy assignments
Get-AzPolicyAssignment -Scope $scope | Remove-AzPolicyAssignment

# Remove custom policy definitions
Get-AzPolicyDefinition -Custom | Where-Object { $_.Properties.Metadata.Category -eq "SC500-Lab" } | Remove-AzPolicyDefinition

Write-Host "Policy assignments and definitions removed."
```

---

## Key Takeaways

- Azure Policy has **no direct cost** — it evaluates and optionally blocks/modifies resources
- **Deny** blocks future non-compliant resources; it does NOT fix existing ones
- **Remediation tasks** fix existing non-compliant resources for DeployIfNotExists/Modify effects
- Policy **non-compliance message** appears in the portal error when a resource is blocked
- Policy propagation takes up to 30 minutes — be patient after assignment
- Custom policies are scoped to a tenant, management group, or subscription
