# Lab 01: Network Security — VNet, Subnets, and NSGs

## Overview

**Estimated Time:** 60–90 minutes  
**Estimated Cost:** ~$1–3 (small test VMs for ~2 hours, then delete)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create a 3-tier network architecture in Azure with proper segmentation, NSG rules, and Application Security Groups.

**Why this matters:**

- Network segmentation is a core Zero Trust principle — limit lateral movement
- NSG misconfiguration (e.g., port 22/3389 open to internet) is a top Azure security finding
- You'll understand how RBAC and network controls combine for defence-in-depth

**Architecture:**

```text
VNet: vnet-sc500-lab (10.0.0.0/16)
├── snet-frontend (10.0.1.0/24)  ← NSG: allow 443 in from internet
├── snet-backend  (10.0.2.0/24)  ← NSG: allow 8080 from frontend only
├── snet-data     (10.0.3.0/24)  ← NSG: allow 1433 from backend only
└── AzureBastionSubnet (10.0.4.0/26) ← No NSG (Bastion manages its own)
```text
---

## Prerequisites

- `rg-sc500-lab` resource group exists
- Owner or Contributor RBAC on the resource group

---

## Part 1: Create the Virtual Network

### Step 1.1 — Create the VNet

1. In Azure Portal, search for **Virtual networks** → click **+ Create**
1. **Basics tab:**
   - **Subscription:** Your subscription
   - **Resource group:** `rg-sc500-lab`
   - **Name:** `vnet-sc500-lab`
   - **Region:** East US
1. **IP Addresses tab:**
   - **Address space:** `10.0.0.0/16`
   - Delete the default subnet if present
   - Click **+ Add subnet:**
     - Name: `snet-frontend`, Starting address: `10.0.1.0`, Size: `/24`
   - Click **+ Add subnet:**
     - Name: `snet-backend`, Starting address: `10.0.2.0`, Size: `/24`
   - Click **+ Add subnet:**
     - Name: `snet-data`, Starting address: `10.0.3.0`, Size: `/24`
   - Click **+ Add subnet:**
     - Name: `AzureBastionSubnet`, Starting address: `10.0.4.0`, Size: `/26`
1. Click **Review + create** → **Create**

---

## Part 2: Create Network Security Groups

### Step 2.1 — Create NSG for frontend

1. Search for **Network security groups** → **+ Create**
1. **Resource group:** `rg-sc500-lab`
1. **Name:** `nsg-frontend`
1. **Region:** East US
1. Click **Review + create** → **Create**

### Step 2.2 — Add inbound rules to nsg-frontend

1. Open `nsg-frontend` → **Inbound security rules** → **+ Add**
1. Add rule 1 (Allow HTTPS):
   - **Source:** Any | **Source port ranges:** * | **Destination:** Any
   - **Service:** HTTPS | **Action:** Allow | **Priority:** 100
   - **Name:** `Allow-HTTPS-Inbound`
1. Add rule 2 (Deny all other inbound):
   - **Source:** Any | **Destination:** Any | **Destination port ranges:** *
   - **Protocol:** Any | **Action:** Deny | **Priority:** 4000
   - **Name:** `Deny-All-Inbound`

### Step 2.3 — Create and configure NSG for backend

Create `nsg-backend` and add:

- Rule: Allow TCP 8080 from **10.0.1.0/24** (frontend subnet), Priority 100, Name: `Allow-Frontend-8080`
- Rule: Deny all inbound, Priority 4000

### Step 2.4 — Create and configure NSG for data tier

Create `nsg-data` and add:

- Rule: Allow TCP 1433 from **10.0.2.0/24** (backend subnet), Priority 100, Name: `Allow-Backend-SQL`
- Rule: Deny all inbound, Priority 4000

### Step 2.5 — Associate NSGs with subnets

For each NSG:

1. Open NSG → **Subnets** → **+ Associate**
1. Select:
   - `nsg-frontend` → `snet-frontend`
   - `nsg-backend` → `snet-backend`
   - `nsg-data` → `snet-data`

---

## Part 3: Create Application Security Groups

### Step 3.1 — Create ASGs

1. Search for **Application security groups** → **+ Create**
1. Create three ASGs in `rg-sc500-lab`:
   - `asg-web-servers`
   - `asg-app-servers`
   - `asg-db-servers`

---

## Part 4: Deploy Test VMs

### Step 4.1 — Deploy a VM in snet-frontend

1. Search for **Virtual machines** → **+ Create** → **Azure virtual machine**
1. **Basics:**
   - RG: `rg-sc500-lab`
   - Name: `vm-frontend-01`
   - Region: East US
   - Image: Ubuntu Server 22.04 LTS
   - Size: Standard_B1s
   - Authentication: Password (for lab purposes)
1. **Networking:**
   - VNet: `vnet-sc500-lab`
   - Subnet: `snet-frontend`
   - **Public IP:** None (we'll use Bastion)
   - **NIC NSG:** None (subnet NSG already applied)
1. **Management:**
   - Enable **Auto-shutdown** at 18:00 UTC
1. Click **Review + create** → **Create**

---

## Part 5: Enable NSG Flow Logs

NSG Flow Logs record which flows are allowed/denied, enabling traffic analysis.

### Step 5.1 — Enable flow logs

1. Open `nsg-frontend` → **NSG flow logs** → **+ Create**
1. **Storage account:** Create new → `stsc500flowlogs<random>`
1. **Retention:** 7 days
1. **Traffic Analytics:** Enable (optional, provides visual analytics)
1. Click **Save**

---

## ARM Template Deployment

```bash
# Deploy the full network using ARM template
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/vnet-with-nsg.json \
  --parameters vnetName=vnet-sc500-lab location=eastus
```text
```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\vnet-with-nsg.json" `
  -vnetName "vnet-sc500-lab" `
  -location "eastus"
```text
---

## Validation Steps

```powershell
# Verify VNet and subnets
Get-AzVirtualNetwork -Name "vnet-sc500-lab" -ResourceGroupName "rg-sc500-lab" |
    Select-Object -ExpandProperty Subnets |
    Format-Table Name, AddressPrefix

# Verify NSG rules on frontend NSG
(Get-AzNetworkSecurityGroup -Name "nsg-frontend" -ResourceGroupName "rg-sc500-lab").SecurityRules |
    Format-Table Name, Priority, Direction, Access, DestinationPortRange

# Verify NSG-subnet associations
$nsg = Get-AzNetworkSecurityGroup -Name "nsg-frontend" -ResourceGroupName "rg-sc500-lab"
$nsg.Subnets | ForEach-Object { Write-Host "NSG associated with subnet: $($_.Id.Split('/')[-1])" }
```text
---

## Troubleshooting

| Issue | Cause | Resolution |
| ------- | ------- | ----------- |
| Cannot reach VM on port 443 | NSG rule not matching | Check NSG effective security rules on NIC |
| NSG rule not applying | NSG not associated with subnet/NIC | Verify association in NSG → Subnets |
| Two NSGs in conflict | NSG on subnet AND NSG on NIC | Both apply; NIC NSG takes precedence for inbound |
| Flow logs not appearing | Storage account not accessible | Check storage account network rules; allow Azure services |

**Check effective NSG rules:**

1. VM → Networking → Network Interface
1. Click **Effective security rules**
1. See all applied NSG rules from both NIC and subnet NSGs

---

## Cleanup Instructions

```powershell
# Remove all network resources in the resource group
$rg = "rg-sc500-lab"
Remove-AzVirtualNetwork -Name "vnet-sc500-lab" -ResourceGroupName $rg -Force
Remove-AzNetworkSecurityGroup -Name "nsg-frontend" -ResourceGroupName $rg -Force
Remove-AzNetworkSecurityGroup -Name "nsg-backend" -ResourceGroupName $rg -Force
Remove-AzNetworkSecurityGroup -Name "nsg-data" -ResourceGroupName $rg -Force
# Or run cleanup-resources.ps1
```text
---

## Key Takeaways

- NSGs provide Layer 4 (TCP/UDP) stateful filtering at subnet and NIC level
- Always use a **deny-all** rule at high priority to ensure default-deny posture
- NSG rules are evaluated by **priority** (lower number = evaluated first)
- ASGs simplify NSG management for multi-VM scenarios
- **Never expose port 22 or 3389 to Internet** — use Azure Bastion instead
- NSG Flow Logs are essential for security investigations
