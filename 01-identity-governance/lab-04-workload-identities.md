# Lab 04: Workload Identities and Managed Identities

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$1-3 (small App Service or VM for a short lab window)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create a user-assigned managed identity, assign it least-privilege
roles to Key Vault and Storage, attach it to a workload, and validate
secretless access. You will also compare this to an app registration with
federated credentials for CI/CD.

**Why this matters for SC-500:**
- Modern Microsoft security guidance strongly prefers **managed identity over secrets**
- SC-500 tests the difference between **app registration**, **service principal**,
  **managed identity**, and **federated credentials**
- Many scenario questions ask how to give a workload access **without storing a secret**

**Architecture:**

```text
[Workload: App Service or VM]
        |
        | uses managed identity token
        v
[User-assigned Managed Identity: mi-sc500-workload]
        |                         |
        | RBAC: Secrets User      | RBAC: Storage Blob Data Reader
        v                         v
[Key Vault: kv-sc500-lab]     [Storage Account: stsc500lab<suffix>]
```

---

## Prerequisites

- `kv-sc500-lab` from Domain 4 Lab 01
- A storage account from Domain 4 Lab 01
- Contributor on `rg-sc500-lab`
- User Access Administrator or Owner to assign roles

---

## Part 1: Create a user-assigned managed identity

### Step 1.1 - Create the identity

1. In Azure Portal, search for **Managed identities** -> **+ Create**
2. Configure:
   - **Resource group:** `rg-sc500-lab`
   - **Name:** `mi-sc500-workload`
   - **Region:** East US
3. Click **Review + create** -> **Create**

### Step 1.2 - Capture the identity details

4. Open the new identity
5. Note:
   - **Client ID**
   - **Object (principal) ID**
   - **Resource ID**

---

## Part 2: Grant least-privilege access

### Step 2.1 - Grant Key Vault read access

1. Open `kv-sc500-lab`
2. Go to **Access control (IAM)**
3. Add role assignment:
   - **Role:** Key Vault Secrets User
   - **Member:** `mi-sc500-workload`

### Step 2.2 - Grant Storage data-plane access

1. Open your storage account
2. Go to **Access control (IAM)**
3. Add role assignment:
   - **Role:** Storage Blob Data Reader
   - **Member:** `mi-sc500-workload`

> Notice that this is **data-plane RBAC**, not just Contributor on the storage account.

---

## Part 3: Attach the identity to a workload

Use whichever workload is easiest in your lab:
- **Option A:** App Service
- **Option B:** Azure VM

### Option A - App Service

1. Create or reuse a basic App Service
2. Open **Identity**
3. Under **User assigned**, click **+ Add**
4. Select `mi-sc500-workload`
5. Save

### Option B - Azure VM

1. Open a test VM
2. Go to **Identity**
3. Under **User assigned**, click **+ Add**
4. Select `mi-sc500-workload`
5. Save

---

## Part 4: Test secretless access

### Step 4.1 - Put a secret in Key Vault

1. Open `kv-sc500-lab`
2. Go to **Secrets** -> **+ Generate/Import**
3. Name: `sc500-demo-secret`
4. Value: `SecretlessAccessWorks`
5. Create the secret

### Step 4.2 - Retrieve the secret using the managed identity

From the workload:

```bash
# VM example
az login --identity --username <managed-identity-client-id>
az keyvault secret show --vault-name kv-sc500-lab --name sc500-demo-secret --query value -o tsv
```

Expected result: the secret value is returned without any secret, certificate,
or connection string stored in the script.

### Step 4.3 - Test blob read access

```bash
az login --identity --username <managed-identity-client-id>
az storage blob list \
  --account-name <storage-account-name> \
  --container-name <container-name> \
  --auth-mode login
```

Expected result: the workload can read allowed data using Entra-issued tokens.

---

## Part 5: Compare to app registrations and federated credentials

### Step 5.1 - Review the identity model

Open **Microsoft Entra ID** and compare:

- **App registration** = application definition
- **Service principal** = the app's identity inside a tenant
- **Managed identity** = Azure-managed service principal for a workload
- **Federated credential** = lets GitHub Actions or another trusted issuer get tokens without storing a secret

### Step 5.2 - Optional CI/CD extension

1. Create an app registration for GitHub Actions
2. Add a **federated credential**
3. Map it to your repo/branch
4. Use OIDC in GitHub Actions instead of a client secret

> This is a strong exam scenario: **"How do I let CI/CD deploy without storing credentials?"**

---

## Validation Steps

```powershell
# Validate the identity exists
Get-AzUserAssignedIdentity -ResourceGroupName "rg-sc500-lab" -Name "mi-sc500-workload"

# Validate role assignments
Get-AzRoleAssignment -ObjectId <managed-identity-object-id> |
    Select-Object RoleDefinitionName, Scope
```

Confirm:
- The workload can access Key Vault and Storage with **token-based auth**
- No password, client secret, or connection string is required
- Role assignments are scoped narrowly to the needed resources

---

## Exam traps

- **Managed identity** is the right answer when the workload runs in Azure
- **Federated credential** is often the right answer for GitHub Actions or external CI/CD
- **App registration** is not the same as **managed identity**
- **Contributor** on a storage account does not automatically grant **blob data access**

---

## Cleanup Instructions

1. Remove the managed identity from the workload
2. Delete the test secret from Key Vault
3. Delete the managed identity if not needed
4. Remove any temporary role assignments

---

## References

- <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview>
- <https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/storage>
- <https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect>
