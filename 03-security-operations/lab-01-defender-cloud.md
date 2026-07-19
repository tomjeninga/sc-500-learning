# Lab 01: Defender for Cloud — Enable Plans and Review Secure Score

## Overview

**Estimated Time:** 45–60 minutes  
**Estimated Cost:** Free tier (Foundational CSPM is free). Enabling paid Defender plans costs ~$0.02–0.15/server/hour — enable only briefly for this lab, then disable.  
**Difficulty:** Beginner–Intermediate

---

## What You'll Build and WHY

You will enable Microsoft Defender for Cloud, review your Secure Score, enable the Defender for Servers plan on your lab resource group, and remediate one recommendation.

**Why this matters:**
- Defender for Cloud is tested heavily on SC-500
- Understanding Secure Score mechanics is directly on the exam
- Remediating recommendations is a core job function for security engineers

---

## Prerequisites

- Azure subscription with `rg-sc500-lab` resource group
- Security Admin or Security Reader role (Reader to view, Admin to remediate)
- At least one VM deployed in `rg-sc500-lab` (from Domain 2 lab) for Defender for Servers

---

## Part 1: Enable Defender for Cloud (Foundational CSPM — Free)

### Step 1.1 — Access Defender for Cloud

1. Open [https://portal.azure.com](https://portal.azure.com)
2. Search for **Microsoft Defender for Cloud** in the top search bar
3. Click the result — this opens the Defender for Cloud overview

### Step 1.2 — Review the Overview Dashboard

4. Review the dashboard:
   - **Secure Score:** Your current score (percentage)
   - **Active recommendations:** Number of open recommendations
   - **Security alerts:** Any active threats
   - **Regulatory compliance:** Compliance against frameworks
5. Note your initial Secure Score — you'll improve it during this lab

### Step 1.3 — Review Environment Settings

6. In the left menu, click **Environment settings**
7. Expand your subscription
8. ✅ You should see the subscription with Defender plans status
9. **Foundational CSPM** should already be enabled (it's always free)

---

## Part 2: Enable Defender for Servers (Paid — Brief Lab Use)

> ⚠️ Defender for Servers costs approximately $0.02–0.10/hour per server. Enable it briefly for this lab, then disable it.

### Step 2.1 — Enable Defender for Servers on the subscription

1. In Environment settings, click on your subscription
2. Find **Servers** in the Defender plans list
3. Toggle **Servers** to **On**
4. Select **Plan 1** (lower cost for lab purposes)
5. Click **Save**

### Step 2.2 — Verify plan is enabled

6. Return to Defender for Cloud overview
7. ✅ The servers plan should show as active

---

## Part 3: Review Secure Score

### Step 3.1 — Explore Secure Score

1. In Defender for Cloud left menu, click **Secure score**
2. Review:
   - **Current score** (percentage)
   - **Secure score over time** chart
   - **Score by subscription**

### Step 3.2 — Review Security Controls

3. Scroll down to see **Security controls** list
4. Note the controls with the highest **Potential score increase**
5. ✅ Common high-impact controls:
   - "Enable MFA for accounts with owner permissions on your subscription"
   - "Remediate vulnerabilities in security configurations on your machines"
   - "Apply system updates"

### Step 3.3 — Drill into a Recommendation

6. Click on any recommendation (e.g., "Enable MFA for accounts with owner permissions")
7. Review:
   - **Affected resources:** Which resources fail this check
   - **Remediation steps:** How to fix it
   - **Quick fix:** Available for some recommendations
   - **Impact:** How many points this recommendation is worth

---

## Part 4: Remediate a Recommendation

### Step 4.1 — Remediate: Enable Storage Account secure transfer

This is a low-cost, high-impact remediation.

1. In Secure Score, search for **"Secure transfer to storage accounts should be enabled"**
2. Click on the recommendation
3. Review affected storage accounts
4. Click **Quick fix** (if available) OR follow the remediation steps:
   - Click the storage account name
   - Go to **Configuration**
   - Under **Secure transfer required**, select **Enabled**
   - Click **Save**

5. Return to the recommendation — the resource should now show as **Healthy**

> Note: Secure Score updates every 30 minutes to a few hours after remediation.

---

## Part 5: Just-in-Time (JIT) VM Access

If you have a VM deployed from Domain 2:

### Step 5.1 — Enable JIT on a VM

1. In Defender for Cloud, click **Workload protections** → **Just-in-time VM access**
2. Click on the **Not Configured** tab
3. Find your test VM (`vm-frontend-01`)
4. Click **Enable JIT on 1 VM**
5. Review the default rules (RDP port 3389, SSH port 22, WinRM 5985/5986)
6. Click **Save**

### Step 5.2 — Request JIT access

7. On the **Configured** tab, select your VM
8. Click **Request access**
9. Set:
   - **Port:** 22 (SSH) or 3389 (RDP)
   - **Allowed source IP:** My IP
   - **Time range:** 3 hours
10. Click **Open ports**
11. ✅ The NSG is temporarily updated to allow your IP on the requested port

---

## Deployment via ARM Template

```bash
# Deploy Log Analytics workspace (prerequisite for Defender data export)
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file ../03-security-operations/templates/log-analytics-workspace.json \
  --parameters workspaceName=law-sc500-lab location=eastus
```

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile "..\03-security-operations\templates\log-analytics-workspace.json" `
  -workspaceName "law-sc500-lab" `
  -location "eastus"
```

---

## Validation Steps

```powershell
# Check Defender for Cloud pricing tier
Get-AzSecurityPricing | Select-Object Name, PricingTier | Format-Table

# Check Secure Score
Get-AzSecuritySecureScore | Select-Object DisplayName, CurrentScore, MaxScore | Format-Table

# List high severity recommendations
Get-AzSecurityTask | Where-Object {$_.State -eq "Active"} | Select-Object -First 10 | Format-Table
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Secure Score not updating | Propagation delay | Wait 30–60 minutes after remediation |
| JIT not available | Defender for Servers not enabled | Enable Defender for Servers Plan 1 |
| Cannot enable Defender plans | Missing permissions | Need Security Admin or Owner role |
| Recommendations not showing | Defender assessment running | Wait up to 24 hrs after enabling |

---

## Cleanup Instructions

```powershell
# Disable Defender for Servers plan (to stop billing)
Set-AzSecurityPricing -Name "VirtualMachines" -PricingTier "Free"

# Verify
Get-AzSecurityPricing -Name "VirtualMachines" | Select-Object Name, PricingTier
```

> Note: Foundational CSPM (free tier) remains enabled — there's no cost.

---

## Key Takeaways

- Defender for Cloud provides both **CSPM** (posture) and **CWPP** (workload protection)
- Secure Score measures alignment with security best practices
- Each security **control** contains multiple **recommendations**
- **Quick Fix** allows one-click remediation for eligible recommendations
- JIT VM Access reduces attack surface by closing management ports by default
- Disable paid Defender plans after the lab to avoid billing
