# Lab 01: Entra ID Setup — Users, Groups & RBAC

## Overview

**Estimated Time:** 60–90 minutes  
**Estimated Cost:** $0 (Entra ID user/group operations are free; resource group operations are free)  
**Difficulty:** Beginner–Intermediate

---

## What You'll Build and WHY

You will create a realistic identity structure in Entra ID representing a small security team, then assign Azure RBAC roles at different scopes to test least-privilege access.

**Why this matters for SC-500:**

- Identity is the heaviest exam domain (~25–30%)
- Understanding RBAC scope inheritance and least-privilege is tested heavily
- You'll configure the foundation that Conditional Access (Lab 02) and PIM build upon

**Architecture:**

```text
Entra ID Tenant
├── User: alice-admin@<tenant>        → Global Reader (directory role)
├── User: bob-security@<tenant>       → Security Reader (directory role)
├── User: charlie-dev@<tenant>        → Contributor (subscription RBAC)
├── Group: grp-sc500-security-readers → Security Reader (RBAC on rg-sc500-lab)
└── Group: grp-sc500-contributors     → Contributor (RBAC on rg-sc500-lab)
```text
---

## Prerequisites

- Azure subscription with `rg-sc500-lab` resource group created
- Global Administrator or User Administrator role in Entra ID
- Az PowerShell module installed and authenticated

---

## Part 1: Create Users in Entra ID

### Step 1.1 — Navigate to Entra ID

1. Open [https://portal.azure.com](https://portal.azure.com)
1. In the search bar, type **Microsoft Entra ID** and click the result
1. You are now on the Entra ID overview page for your tenant

### Step 1.2 — Create User: alice-admin

1. In the left menu, click **Users**
1. Click **+ New user** → **Create new user**
1. Fill in:
   - **User principal name:** `alice-admin` (the domain is auto-filled, e.g., `alice-admin@yourtenant.onmicrosoft.com`)
   - **Display name:** `Alice Admin`
   - **Password:** Click **Auto-generate password** and copy it
1. Expand **Properties**:
   - **Job title:** Security Administrator
   - **Department:** IT Security
1. Click **Review + create** → **Create**
1. ✅ You should see a success notification. Note the UPN.

### Step 1.3 — Create User: bob-security

Repeat Step 1.2 with:

- UPN: `bob-security`
- Display name: `Bob Security`
- Job title: SOC Analyst

### Step 1.4 — Create User: charlie-dev

Repeat Step 1.2 with:

- UPN: `charlie-dev`
- Display name: `Charlie Developer`
- Job title: Platform Engineer

### Step 1.5 — Verify Users Created

1. In Entra ID → **Users**, search for "alice", "bob", and "charlie"
1. ✅ All three users should appear in the list

---

## Part 2: Create Security Groups

### Step 2.1 — Create grp-sc500-security-readers

1. In Entra ID left menu, click **Groups**
1. Click **+ New group**
1. Fill in:
   - **Group type:** Security
   - **Group name:** `grp-sc500-security-readers`
   - **Group description:** SC-500 lab — security reader access
   - **Membership type:** Assigned
1. Click **No members selected** → search for `bob-security` → click **Select**
1. Click **Create**

### Step 2.2 — Create grp-sc500-contributors

Repeat Step 2.1 with:

- **Group name:** `grp-sc500-contributors`
- **Group description:** SC-500 lab — contributor access
- **Members:** Add `charlie-dev`

---

## Part 3: Assign Azure RBAC Roles

### Step 3.1 — Assign Security Reader to the security group on rg-sc500-lab

1. Open [https://portal.azure.com](https://portal.azure.com)
1. Search for **Resource groups** → click `rg-sc500-lab`
1. In the left menu, click **Access control (IAM)**
1. Click **+ Add** → **Add role assignment**
1. In the **Role** tab:
   - Search for `Security Reader`
   - Click on it, then click **Next**
1. In the **Members** tab:
   - **Assign access to:** User, group, or service principal
   - Click **+ Select members**
   - Search for `grp-sc500-security-readers`
   - Click **Select**
1. Click **Review + assign** → **Review + assign**
1. ✅ You should see a success notification

### Step 3.2 — Assign Contributor to the contributors group on rg-sc500-lab

Repeat Step 3.1 with:

- Role: `Contributor`
- Members: `grp-sc500-contributors`

### Step 3.3 — Assign Reader to alice-admin at Subscription scope

1. Search for **Subscriptions** → click your subscription
1. Click **Access control (IAM)** → **+ Add** → **Add role assignment**
1. Role: `Reader`
1. Members: `alice-admin`
1. Click **Review + assign** → **Review + assign**

---

## Part 4: Assign Entra ID Directory Roles

### Step 4.1 — Assign Global Reader to alice-admin

1. In Entra ID → **Roles and administrators**
1. Search for `Global Reader`
1. Click **Global Reader** → **+ Add assignments**
1. Search for `alice-admin` → Click **Select**
1. Click **Add**

### Step 4.2 — Assign Security Reader (Entra ID role) to bob-security

Repeat Step 4.1 with:

- Role: `Security Reader`
- User: `bob-security`

---

## Part 5: Test Least-Privilege

### Step 5.1 — Verify role assignments via Azure Portal

1. Go back to `rg-sc500-lab` → **Access control (IAM)**
1. Click **Role assignments** tab
1. ✅ You should see:
   - `grp-sc500-security-readers` — Security Reader
   - `grp-sc500-contributors` — Contributor
   - `alice-admin` (inherited from subscription) — Reader

### Step 5.2 — Check effective permissions for alice-admin

1. Still on `rg-sc500-lab` → **Access control (IAM)**
1. Click **Check access** tab
1. Search for `alice-admin`
1. ✅ You should see Reader access (inherited from subscription)

---

## ARM Template Deployment

Deploy the role assignments via ARM template:

```bash
# Deploy via Azure CLI
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/rbac-assignments.json \
  --parameters principalId="<object-id-of-grp-sc500-security-readers>"
```text
```powershell
# Deploy via Az PowerShell
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\rbac-assignments.json" `
  -principalId "<object-id-of-grp-sc500-security-readers>"
```text
---

## PowerShell Script Deployment

Run the automated setup script:

```powershell
# Run the setup script (creates users, groups, RBAC assignments)
.\scripts\setup-entra-id-lab.ps1 -ResourceGroupName "rg-sc500-lab" -Location "eastus"
```text
---

## Validation Steps

1. **Check IAM assignments:**

   ```powershell
   Get-AzRoleAssignment -ResourceGroupName "rg-sc500-lab" | Format-Table DisplayName, RoleDefinitionName, Scope
   ```

1. **Check Entra ID groups:**

   ```powershell
   Get-AzADGroup -DisplayName "grp-sc500-security-readers" | Select-Object DisplayName, Id
   ```

1. **Check Entra ID users:**

   ```powershell
   Get-AzADUser -DisplayName "Alice Admin" | Select-Object DisplayName, UserPrincipalName
   ```

---

## Troubleshooting

| Issue | Cause | Resolution |
| ------- | ------- | ----------- |
| "You do not have permission to create users" | Missing User Administrator role | Request User Admin or Global Admin from your tenant owner |
| "Cannot assign role at subscription scope" | Missing Owner or User Access Administrator | Assign at resource group scope only |
| Users not appearing in group | Replication delay | Wait 1–2 minutes and refresh |
| Role assignment not taking effect | Azure RBAC propagation delay | Wait up to 5 minutes |

---

## Cleanup Instructions

```powershell
# Remove RBAC assignments
$rg = "rg-sc500-lab"
Remove-AzRoleAssignment -ResourceGroupName $rg -SignInName "charlie-dev@yourtenant.onmicrosoft.com" -RoleDefinitionName "Contributor"

# Remove users (if no longer needed)
Remove-AzADUser -UPNOrObjectId "alice-admin@yourtenant.onmicrosoft.com"
Remove-AzADUser -UPNOrObjectId "bob-security@yourtenant.onmicrosoft.com"
Remove-AzADUser -UPNOrObjectId "charlie-dev@yourtenant.onmicrosoft.com"

# Remove groups
Remove-AzADGroup -DisplayName "grp-sc500-security-readers"
Remove-AzADGroup -DisplayName "grp-sc500-contributors"
```text
Or run the shared cleanup script:

```powershell
.\scripts\cleanup-resources.ps1
```text
---

## Key Takeaways

- RBAC roles are assigned at a **scope** (subscription, resource group, resource)
- Permissions are **inherited** downward in the scope hierarchy
- Always assign roles to **groups**, not individual users
- Entra ID directory roles and Azure RBAC roles are **separate systems**
- The `Security Reader` role provides read-only access to security information without resource access
