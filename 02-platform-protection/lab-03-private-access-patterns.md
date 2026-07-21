# Lab 03: Private Access Patterns for Storage and SQL

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$2-5 (Private Endpoints, test resources, and short-lived compute)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will lock down Azure Storage and Azure SQL so they are reachable through
private connectivity patterns, validate DNS resolution, and compare Private
Endpoints to Service Endpoints.

**Why this matters for SC-500:**
- SC-500 often asks which network control best protects a PaaS service
- Many candidates confuse **Private Endpoint** and **Service Endpoint**
- You need to know where **NSGs**, **WAF**, **Firewall**, and **Private Link**
  each fit in an end-to-end architecture

**Architecture:**

```text
VNet: vnet-sc500-lab
  ├── snet-backend
  └── snet-data

Private DNS zones
  ├── privatelink.blob.core.windows.net
  └── privatelink.database.windows.net

Private Endpoints
  ├── pe-storage-sc500 -> Storage blob endpoint
  └── pe-sql-sc500     -> Azure SQL server endpoint
```

---

> **Depends on:** `02-platform-protection/lab-01-network-security.md`, `04-data-protection/lab-01-storage-encryption.md`, `04-data-protection/lab-02-database-security.md`, and a test VM in the VNet
> **Reused by:** no required follow-up lab; this is usually the last consumer of the shared VNet, storage, and SQL chain
> **Delete after:** you finish DNS and connectivity validation for Storage and SQL private access

## Prerequisites

- `vnet-sc500-lab` and `snet-data` from Module 2 Lab 01
- A storage account from Module 4 Lab 01
- An Azure SQL server from Module 4 Lab 02
- A VM in the VNet for DNS/connectivity testing

---

## Part 1: Review the control choices

Before you build, make sure you can explain:

- **NSG:** packet filtering for subnet/NIC traffic
- **WAF:** HTTP/S inspection for web apps
- **Private Endpoint:** private NIC into your VNet for a PaaS resource
- **Service Endpoint:** keeps service public but restricts access to selected VNets
- **SQL/Storage firewall:** service-native allow/deny boundary

> If the exam says **remove public exposure** for Storage or SQL, the answer is
> usually **Private Endpoint**, not NSG or WAF.

---

## Part 2: Lock down the storage account

### Step 2.1 - Confirm current state

1. Open your storage account
2. Go to **Networking**
3. Review:
   - **Public network access**
   - **Firewall and virtual networks**
   - **Private endpoint connections**

### Step 2.2 - Create or verify the Storage Private Endpoint

1. If not already created in Module 4 Lab 01, add a private endpoint:
   - **Name:** `pe-storage-sc500`
   - **Target sub-resource:** `blob`
   - **VNet:** `vnet-sc500-lab`
   - **Subnet:** `snet-data`
   - **Private DNS integration:** Yes
2. Disable public network access
3. Save

---

## Part 3: Add a Private Endpoint for Azure SQL

### Step 3.1 - Create the SQL Private Endpoint

1. Open your Azure SQL server
2. Go to **Networking** -> **Private access**
3. Click **+ Private endpoint**
4. Configure:
   - **Name:** `pe-sql-sc500`
   - **Resource group:** `rg-sc500-lab`
   - **VNet:** `vnet-sc500-lab`
   - **Subnet:** `snet-data`
   - **Private DNS integration:** Yes
5. Create the private endpoint

### Step 3.2 - Restrict public access

1. In SQL server networking settings:
   - Turn **Public network access** to **Disabled** for the final state
2. If you still need to test from your local machine, do that first, then disable it

---

## Part 4: Validate private DNS resolution

### Step 4.1 - Check Storage name resolution

From a VM inside the VNet:

```bash
nslookup <storage-account-name>.blob.core.windows.net
```

Expected result: the hostname resolves to a **10.x** private IP through
`privatelink.blob.core.windows.net`.

### Step 4.2 - Check SQL name resolution

```bash
nslookup <sql-server-name>.database.windows.net
```

Expected result: the SQL server name resolves to a **10.x** private IP through
`privatelink.database.windows.net`.

---

## Part 5: Test access from the right place and the wrong place

### Step 5.1 - From inside the VNet

From the test VM:

```powershell
# Test TCP connectivity to SQL
Test-NetConnection -ComputerName "<sql-server-name>.database.windows.net" -Port 1433
```

Expected result: connection succeeds.

### Step 5.2 - From outside the VNet

From your local machine or Cloud Shell, try accessing the same SQL endpoint
after public access is disabled.

Expected result: connection fails or times out because only private access exists.

### Step 5.3 - Validate Storage isolation

Try listing blobs without going through a connected identity and approved network path.

Expected result: access is blocked by network rules or private-only configuration.

---

## Part 6: Compare Private Endpoint vs Service Endpoint

Create a short comparison table in your notes:

| Control | Public endpoint remains? | Private IP in your VNet? | Typical exam use |
| --- | --- | --- | --- |
| Private Endpoint | No (if you disable it) | Yes | Best for sensitive PaaS isolation |
| Service Endpoint | Yes | No | Restrict access from specific VNets |

**Memorize this rule:**
- If the requirement says **"keep traffic off the public internet and use a private IP"**, use **Private Endpoint**
- If the requirement says **"allow access only from my VNet but the service may stay public"**, use **Service Endpoint**

---

## Validation Steps

```powershell
# Check private endpoints
Get-AzPrivateEndpoint -ResourceGroupName "rg-sc500-lab" |
    Select-Object Name, NetworkInterfaces

# Check private DNS zones
Get-AzPrivateDnsZone -ResourceGroupName "rg-sc500-lab" |
    Select-Object Name
```

Confirm:
- Storage and SQL both have private endpoints
- DNS resolves to private IPs
- Public access is disabled for the final secure state

---

## Exam traps

- **NSG** does not create private access to Storage or SQL
- **WAF** protects web traffic, not data-plane access to Storage or SQL
- **Private Endpoint** is usually preferred over **Service Endpoint** for sensitive workloads
- **DNS** is part of the solution; if name resolution is wrong, Private Link often "looks broken"

---

## Cleanup Instructions

1. Remove private endpoints if you need to reduce lab costs
2. Remove private DNS zones if they were created only for testing
3. Re-enable public access only if you specifically need it for later labs

---

## References

- <https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview>
- <https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints>
- <https://learn.microsoft.com/en-us/azure/azure-sql/database/private-endpoint-overview>
