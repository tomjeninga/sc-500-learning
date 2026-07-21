# Lab 01: Storage Account Encryption with Customer-Managed Keys

## Overview

**Estimated Time:** 45–60 minutes  
**Estimated Cost:** ~$0.50–2 (Key Vault: free tier for lab; Storage: minimal blob storage costs)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create an Azure Key Vault, generate an encryption key, create a storage account, configure it to use Customer-Managed Keys (CMK) from Key Vault, deploy a Private Endpoint, and disable public network access.

**Why this matters:**

- CMK is a common compliance requirement for regulated industries
- Private Endpoints are the recommended approach for isolating PaaS storage
- SC-500 tests CMK configuration, Key Vault RBAC, and storage isolation controls

**Architecture:**

```text
[Key Vault: kv-sc500-lab]
  └── Key: storage-cmk-key (RSA 2048)
        ↑ used to encrypt
[Storage Account: stsc500lab<suffix>]
  ├── Encryption: CMK via Key Vault (using Managed Identity)
  ├── Public network access: Disabled
  └── Private Endpoint → snet-data subnet
```text
---

## Prerequisites

- `rg-sc500-lab` resource group
- `vnet-sc500-lab` with `snet-data` subnet (from Domain 2 Lab 01)
- Owner or Contributor + Key Vault Crypto Officer on `rg-sc500-lab`

---

## Part 1: Create Azure Key Vault

### Step 1.1 — Create Key Vault

1. In Azure Portal, search for **Key vaults** → **+ Create**
1. **Basics:**
   - **Resource group:** `rg-sc500-lab`
   - **Key vault name:** `kv-sc500-lab` (must be globally unique — append suffix if needed)
   - **Region:** East US
   - **Pricing tier:** Standard
1. **Access configuration tab:**
   - **Permission model:** Azure role-based access control (RBAC)
1. **Networking tab:**
   - **Allow access from:** All networks (we'll restrict later; lab simplification)
1. Click **Review + create** → **Create**

### Step 1.2 — Enable Soft Delete and Purge Protection

1. Once deployed, open your Key Vault
1. Go to **Properties**
1. Verify:
   - **Soft delete:** Enabled ✅ (on by default for new Key Vaults)
   - **Purge protection:** Enable it (for production use — optional for lab)
1. Click **Save** if you made changes

### Step 1.3 — Assign yourself Key Vault Crypto Officer

1. Open Key Vault → **Access control (IAM)** → **+ Add** → **Add role assignment**
1. Role: **Key Vault Crypto Officer**
1. Members: Your user account
1. Click **Review + assign**

---

## Part 2: Create an Encryption Key

### Step 2.1 — Generate the CMK

1. Open Key Vault → **Keys** → **+ Generate/Import**
1. Configure:
   - **Method of key creation:** Generate
   - **Name:** `storage-cmk-key`
   - **Key type:** RSA
   - **RSA key size:** 2048
   - **Enabled:** Yes
   - **Expiration date:** Set to 1 year from now (good practice)
1. Click **Create**

### Step 2.2 — Note the Key Identifier

1. Click on `storage-cmk-key` → click the current version
1. Note the **Key Identifier** URL — you'll reference it in the storage account

---

## Part 3: Create Storage Account with CMK

### Step 3.1 — Create Storage Account

1. Search for **Storage accounts** → **+ Create**
1. **Basics:**
   - **Resource group:** `rg-sc500-lab`
   - **Storage account name:** `stsc500lab` + 4-6 random digits (must be globally unique, lowercase)
   - **Region:** East US
   - **Performance:** Standard
   - **Redundancy:** LRS (lowest cost for lab)
1. **Advanced tab:**
   - **Require secure transfer for REST API operations:** Enabled
   - **Enable storage account key access:** Disabled (use Entra ID / CMK only)
   - **Minimum TLS version:** TLS 1.2
1. **Encryption tab:**
   - **Encryption type:** Customer-managed keys
   - **Key store type:** Key vault
   - **Key vault:** Select `kv-sc500-lab`
   - **Key:** Select `storage-cmk-key`
   - **User-assigned identity:** Create new → name: `mi-sc500-storage`
1. **Networking tab:**
   - **Network access:** Disable public access and use private access
1. Click **Review + create** → **Create**

> Note: If you get an error about the managed identity not having Key Vault permissions, complete Step 3.2 first.

### Step 3.2 — Grant Managed Identity access to Key Vault

If the managed identity needs to be granted access separately:

1. Open Key Vault → **Access control (IAM)** → **+ Add** → **Add role assignment**
1. Role: **Key Vault Crypto Service Encryption User**
1. Members: The managed identity `mi-sc500-storage`
1. Click **Review + assign**

---

## Part 4: Configure Private Endpoint

### Step 4.1 — Create Private Endpoint for Storage

1. Open your Storage account → **Networking** → **Private endpoint connections** → **+ Private endpoint**
1. **Basics:**
   - **Resource group:** `rg-sc500-lab`
   - **Name:** `pe-storage-sc500`
   - **Region:** East US
1. **Resource tab:**
   - **Resource type:** Microsoft.Storage/storageAccounts
   - **Resource:** Your storage account
   - **Target sub-resource:** blob
1. **Virtual Network tab:**
   - **Virtual network:** `vnet-sc500-lab`
   - **Subnet:** `snet-data`
   - **Private DNS integration:** Yes → `privatelink.blob.core.windows.net`
1. Click **Review + create** → **Create**

### Step 4.2 — Verify connectivity

1. After deployment, open the Private Endpoint resource
1. Check **DNS configuration** — should show a private IP address mapped to your storage account FQDN

---

## Part 5: Test Access

### Step 5.1 — Test that public access is blocked

```powershell
# This should fail with AuthorizationFailure or network error
$storageAccountName = "stsc500lab<yoursuffix>"
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount
Get-AzStorageContainer -Context $ctx
# Expected: Error — public access disabled
```text
### Step 5.2 — Test via private endpoint (from VM in VNet)

From a VM deployed in `snet-data` or `snet-backend`:

```bash
# Should resolve to private IP (10.0.3.x)
nslookup stsc500lab<suffix>.blob.core.windows.net
```text
---

## ARM Template Deployment

```bash
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/storage-account-encrypted.json \
  --parameters storageAccountName=stsc500lab<suffix> keyVaultName=kv-sc500-lab
```text
```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\storage-account-encrypted.json" `
  -storageAccountName "stsc500lab<suffix>" `
  -keyVaultName "kv-sc500-lab"
```text
---

## Validation Steps

```powershell
$rg = "rg-sc500-lab"
$storageAccountName = "stsc500lab<suffix>"

# Verify CMK is configured
$storage = Get-AzStorageAccount -ResourceGroupName $rg -Name $storageAccountName
Write-Host "CMK Key Source: $($storage.Encryption.KeySource)"
Write-Host "Key Vault URI: $($storage.Encryption.KeyVaultProperties.KeyVaultUri)"
Write-Host "Key Name: $($storage.Encryption.KeyVaultProperties.KeyName)"

# Verify public access is disabled
Write-Host "Public Network Access: $($storage.PublicNetworkAccess)"
# Expected: Disabled

# Check private endpoint
$pe = Get-AzPrivateEndpoint -ResourceGroupName $rg -Name "pe-storage-sc500"
Write-Host "Private Endpoint: $($pe.Name) - State: $($pe.ProvisioningState)"
```text
---

## Troubleshooting

| Issue | Cause | Resolution |
| ------- | ------- | ----------- |
| "The specified key is not accessible" | Managed identity lacks Key Vault permissions | Assign Key Vault Crypto Service Encryption User role |
| Cannot access storage after private endpoint | DNS not resolving to private IP | Ensure private DNS zone is linked to VNet |
| Storage account creation fails | Name already taken (globally unique) | Add more random suffix |
| Key rotation fails | Soft delete enabled, old key in recovery | Wait for soft-delete period or recover the key |

---

## Cleanup Instructions

```powershell
$rg = "rg-sc500-lab"

# Remove storage account
Remove-AzStorageAccount -ResourceGroupName $rg -Name "stsc500lab<suffix>" -Force

# Remove private endpoint
Remove-AzPrivateEndpoint -ResourceGroupName $rg -Name "pe-storage-sc500" -Force

# Remove Key Vault (soft-deleted; purge if needed)
Remove-AzKeyVault -VaultName "kv-sc500-lab" -ResourceGroupName $rg -Force
# To purge (permanently delete after soft-delete):
# Remove-AzKeyVault -VaultName "kv-sc500-lab" -InRemovedState -Force
```text
---

## Key Takeaways

- CMK provides **key sovereignty** — you control the key, which means you can revoke data access
- Key Vault must use **RBAC permission model** for managed identity access to work cleanly
- Private Endpoint requires a **private DNS zone** to ensure proper name resolution
- Disabling public access on storage + private endpoint = **zero public internet exposure**
- Key rotation updates the DEK wrapper; data is **not re-encrypted** during rotation
