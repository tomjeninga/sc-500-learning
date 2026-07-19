# Azure Environment Setup Guide

## Overview

This guide walks you through creating an Azure subscription, installing the required tools, setting up the `rg-sc500-lab` resource group, configuring budget alerts, and applying cost-saving practices for this learning lab.

---

## Step 1: Create an Azure Subscription

### Option A: Azure Free Account (Recommended for beginners)

1. Go to [https://azure.microsoft.com/free](https://azure.microsoft.com/free)
2. Click **Start free**
3. Sign in with a Microsoft account (create one if needed)
4. Enter your details:
   - Phone number (for verification)
   - Credit/debit card (for identity verification — **not charged during free tier**)
5. Complete identity verification
6. Accept the agreement and click **Sign up**

**Free tier includes:**
- 12 months of popular free services
- $200 Azure credit (first 30 days)
- 55+ always-free services

> ⚠️ **Important:** The SC-500 labs are designed to minimize costs, but some services (App Gateway WAF, Defender for Cloud plans) have costs. Keep the `rg-sc500-lab` isolated and run cleanup scripts after each lab.

### Option B: Visual Studio / MSDN Subscription

If you have a Visual Studio subscription, activate your monthly Azure credit at [https://my.visualstudio.com/benefits](https://my.visualstudio.com/benefits).

---

## Step 2: Install Azure CLI

### Windows

```powershell
# Option 1: winget (recommended)
winget install -e --id Microsoft.AzureCLI

# Option 2: MSI installer
# Download from https://aka.ms/installazurecliwindows
```

### macOS

```bash
brew update && brew install azure-cli
```

### Linux (Ubuntu/Debian)

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Verify Installation

```bash
az --version
az login
```

---

## Step 3: Install Az PowerShell Module

```powershell
# Install PowerShell 7+ if not already installed
# https://github.com/PowerShell/PowerShell/releases

# Install Az module (run PowerShell as Administrator)
Install-Module -Name Az -Repository PSGallery -Force -AllowClobber

# Verify installation
Get-Module -Name Az -ListAvailable | Select-Object Name, Version | Sort-Object Version -Descending | Select-Object -First 5

# Connect to Azure
Connect-AzAccount
```

> 💡 **Tip:** If you receive an execution policy error, run:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

---

## Step 4: Set Up the Lab Resource Group

All SC-500 lab resources should be deployed into a dedicated resource group for easy tracking and cleanup.

### Using Az PowerShell

```powershell
# Connect to Azure (if not already connected)
Connect-AzAccount

# Set your subscription (replace with your subscription ID)
$subscriptionId = "YOUR_SUBSCRIPTION_ID"
Set-AzContext -SubscriptionId $subscriptionId

# Create the lab resource group
$rgParams = @{
    Name     = "rg-sc500-lab"
    Location = "eastus"  # Change to your preferred region
}
New-AzResourceGroup @rgParams -Tag @{
    Purpose     = "SC-500 Learning Lab"
    Owner       = "YourName"
    CostCenter  = "Learning"
    AutoDelete  = "true"
}

Write-Host "Resource group created: rg-sc500-lab" -ForegroundColor Green
```

### Using Azure CLI

```bash
az group create \
  --name rg-sc500-lab \
  --location eastus \
  --tags Purpose="SC-500 Learning Lab" Owner="YourName" CostCenter="Learning"
```

### Using Azure Portal

1. Open [https://portal.azure.com](https://portal.azure.com)
2. Search for **Resource groups** in the top search bar
3. Click **+ Create**
4. Fill in:
   - **Subscription:** Your subscription
   - **Resource group name:** `rg-sc500-lab`
   - **Region:** East US (or your nearest region)
5. Click **Review + create** → **Create**

---

## Step 5: Configure Budget Alerts

Avoid surprise costs by setting up a monthly budget alert.

### Using Azure Portal

1. Search for **Cost Management + Billing** in the portal
2. Select **Cost Management** → **Budgets**
3. Click **+ Add**
4. Configure:
   - **Name:** `sc500-lab-budget`
   - **Reset period:** Monthly
   - **Creation date:** Today
   - **Expiration date:** 6 months from now
   - **Budget amount:** $30 (adjust to your comfort level)
5. Click **Next: Alerts**
6. Add an alert condition:
   - **Type:** Actual
   - **% of budget:** 80
   - **Action group:** Create new → enter your email
7. Add a second alert:
   - **Type:** Forecasted
   - **% of budget:** 100
8. Click **Create**

### Using Az PowerShell

```powershell
# Note: Budget creation requires Az.CostManagement module
Install-Module -Name Az.CostManagement -Force

# Get your subscription scope
$subscriptionId = (Get-AzContext).Subscription.Id
$scope = "/subscriptions/$subscriptionId"

# Create a budget (via REST API - Az module wrapper)
$startDate = (Get-Date -Day 1).ToString("yyyy-MM-dd")
$endDate = (Get-Date).AddMonths(6).ToString("yyyy-MM-dd")

New-AzConsumptionBudget `
    -Name "sc500-lab-budget" `
    -Amount 30 `
    -Category Cost `
    -TimeGrain Monthly `
    -StartDate $startDate `
    -EndDate $endDate `
    -ContactEmail @("your-email@example.com") `
    -NotificationKey "Alert80Percent" `
    -NotificationEnabled $true `
    -NotificationThreshold 80 `
    -NotificationThresholdType Actual
```

---

## Step 6: Verify Your Setup

Run this script to verify everything is configured correctly:

```powershell
# Verify Az module
$azModule = Get-Module -Name Az -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
Write-Host "Az Module Version: $($azModule.Version)" -ForegroundColor Cyan

# Verify login
$context = Get-AzContext
if ($context) {
    Write-Host "Logged in as: $($context.Account)" -ForegroundColor Green
    Write-Host "Subscription: $($context.Subscription.Name)" -ForegroundColor Green
} else {
    Write-Warning "Not logged in. Run: Connect-AzAccount"
}

# Verify resource group
$rg = Get-AzResourceGroup -Name "rg-sc500-lab" -ErrorAction SilentlyContinue
if ($rg) {
    Write-Host "Resource group 'rg-sc500-lab' exists in: $($rg.Location)" -ForegroundColor Green
} else {
    Write-Warning "Resource group 'rg-sc500-lab' not found. Create it first."
}

# Verify Azure CLI
$cliVersion = az --version 2>$null | Select-Object -First 1
Write-Host "Azure CLI: $cliVersion" -ForegroundColor Cyan
```

---

## Cost-Saving Tips

### 1. Auto-Shutdown VMs

Always enable auto-shutdown on lab VMs (Portal: VM → Auto-shutdown → Enable, set 18:00 local time).

```powershell
# Enable auto-shutdown via PowerShell
$vmName = "vm-sc500-test"
$rgName = "rg-sc500-lab"
$shutdownTime = "1800"  # 6 PM UTC
$timeZone = "UTC"
$subscriptionId = (Get-AzContext).Subscription.Id

$properties = @{
    status = "Enabled"
    taskType = "ComputeVmShutdownTask"
    dailyRecurrence = @{ time = $shutdownTime }
    timeZoneId = $timeZone
    notificationSettings = @{ status = "Disabled" }
    targetResourceId = "/subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.Compute/virtualMachines/$vmName"
}

$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$rgName/providers/microsoft.devtestlab/schedules/shutdown-computevm-$vmName"
New-AzResource -ResourceId $resourceId -Properties $properties -Force
```

### 2. Use Burstable VM Sizes

For lab VMs, use **B-series** (burstable) SKUs instead of D-series:
- `Standard_B1s` — 1 vCPU, 1 GB RAM (~$8/month if left running)
- `Standard_B2s` — 2 vCPU, 4 GB RAM (~$31/month)

### 3. Delete Resources After Each Lab

Always run the cleanup script after completing a lab:

```powershell
# Quick cleanup of all resources in rg-sc500-lab
# WARNING: This deletes everything in the resource group
.\scripts\cleanup-resources.ps1
```

### 4. Avoid Expensive SKUs

| Service | Avoid | Use Instead | Cost Saving |
|---------|-------|-------------|-------------|
| App Gateway | WAF_v2 (production) | WAF_v2 Small (1 instance) | ~80% |
| VPN Gateway | VpnGw1 | Basic | ~60% |
| Firewall | Standard | — (use NSG instead) | 100% |
| DDoS Protection | Standard | Basic (free) | 100% |

### 5. Use Azure Cost Analysis

Regularly review costs:
1. Portal → Cost Management + Billing → Cost analysis
2. Filter by Resource Group: `rg-sc500-lab`
3. Group by: Service name

### 6. Regions with Lower Costs

`East US` and `East US 2` typically offer the lowest pricing for most services.

---

## Recommended VS Code Extensions

Install these for the best editing experience with this repo:

```bash
# Install via VS Code or command line:
code --install-extension ms-azuretools.vscode-azureresourcegroups
code --install-extension ms-azuretools.vscode-bicep
code --install-extension ms-vscode.powershell
code --install-extension redhat.vscode-json
```

---

## Summary: Setup Checklist

- [ ] Azure subscription created (free tier or MSDN)
- [ ] Azure CLI installed (`az --version` returns a version)
- [ ] Az PowerShell module installed (`Get-Module Az -ListAvailable` shows results)
- [ ] Logged in to Azure (`Connect-AzAccount` succeeded)
- [ ] `rg-sc500-lab` resource group created in your preferred region
- [ ] Budget alert configured ($30 budget, email notification at 80%)
- [ ] VS Code installed with Azure extensions (optional)
- [ ] Ready to begin Week 1! 🚀

---

*Next Step:* Return to `ROADMAP.md` and begin Week 2 — Identity & Governance Theory.
