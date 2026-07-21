# Lab 02: Conditional Access Policies

## Overview

**Estimated Time:** 60–90 minutes  
**Estimated Cost:** $0 (Conditional Access policy configuration is free with Entra ID P1/P2)  
**Difficulty:** Intermediate  
**Requires:** Entra ID P1 or P2 license (available in Microsoft 365 E3/E5 or standalone)

---

## What You'll Build and WHY

You will configure three Conditional Access policies that represent real-world security baselines:

1. **Require MFA for all administrators** — Protects high-privilege accounts
1. **Block legacy authentication** — Eliminates a major attack vector (legacy auth bypasses MFA)
1. **Location-based policy** — Requires MFA from untrusted locations

**Why this matters for SC-500:**

- Conditional Access is a core identity security control
- Understanding the policy anatomy (signals + controls) is directly tested
- Report-only mode is a best-practice that is tested on the exam
- Blocking legacy auth is consistently recommended by Microsoft and appears in exam scenarios

---

## Prerequisites

- Entra ID P1 or P2 license (at least 3 test users licensed)
- Completed Lab 01 (users alice-admin, bob-security, charlie-dev exist)
- Global Administrator or Conditional Access Administrator role
- At least one **Named Location** configured (trusted office IP range)

---

## Part 1: Configure a Named Location (Trusted IP)

Named locations define trusted IP ranges used in Conditional Access conditions.

### Step 1.1 — Create a trusted named location

1. Open [https://portal.azure.com](https://portal.azure.com)
1. Navigate to **Microsoft Entra ID** → **Security** → **Conditional Access**
1. In the left menu, click **Named locations**
1. Click **+ IP ranges location**
1. Fill in:
   - **Name:** `Trusted Office Network`
   - Check **Mark as trusted location**
   - Click **+** and enter your office's public IP range in CIDR notation (e.g., `203.0.113.0/24`)
   - If you don't know the IP, go to [https://whatismyip.com](https://whatismyip.com) and enter `<your-ip>/32`
1. Click **Create**

---

## Part 2: Require MFA for Administrators

### Step 2.1 — Create the policy

1. In Conditional Access, click **+ New policy**
1. **Name the policy:** `CA-01: Require MFA for Administrators`

### Step 2.2 — Configure Assignments

1. Click **Users**:
   - Select **Select users and groups**
   - Check **Directory roles**
   - Select: Global Administrator, Security Administrator, User Administrator, Conditional Access Administrator, Privileged Role Administrator
   - Click **Select**

1. Click **Target resources** (formerly Cloud apps):
   - Select **All cloud apps**

1. Click **Conditions** → **Sign-in risk** — Leave at default (Not configured)

### Step 2.3 — Configure Access Controls

1. Click **Grant**:
   - Select **Grant access**
   - Check **Require multifactor authentication**
   - Click **Select**

### Step 2.4 — Set to Report-only First

1. Under **Enable policy**, select **Report-only**
1. Click **Create**

> ⚠️ **Important:** Always use report-only mode first to understand the impact. If you immediately enable it and you are a Global Admin without MFA set up, you could lock yourself out.

### Step 2.5 — Review report-only results

After signing in a few times:

1. In Conditional Access → click your policy
1. Click **Insights and reporting** (or check the **Sign-in logs**)
1. View which sign-ins would have been affected

### Step 2.6 — Enable the Policy

Once you have verified the impact:

1. Edit the policy
1. Change **Enable policy** from **Report-only** to **On**
1. Click **Save**

---

## Part 3: Block Legacy Authentication

Legacy authentication protocols (Basic Auth, NTLM, older Office clients) cannot handle modern MFA challenges. Attackers exploit these to bypass MFA.

### Step 3.1 — Create the policy

1. In Conditional Access, click **+ New policy**
1. **Name:** `CA-02: Block Legacy Authentication`

### Step 3.2 — Configure Assignments

1. **Users:** All users  
   *(Exclude your break-glass emergency admin account if you have one)*

1. **Target resources:** All cloud apps

1. **Conditions** → **Client apps**:
   - Click **Yes** to configure
   - Check: **Exchange ActiveSync clients**
   - Check: **Other clients**
   - (Leave **Browser** and **Mobile apps and desktop clients** unchecked — these support modern auth)
   - Click **Done**

### Step 3.3 — Configure Access Controls

1. **Grant**: **Block access** → Click **Select**

1. **Enable policy**: **Report-only** (test first)

1. Click **Create**

> 💡 **Why this matters:** Microsoft reports that over 97% of credential stuffing attacks and a significant portion of password spray attacks use legacy auth protocols. Blocking legacy auth is one of the highest-impact security actions you can take.

---

## Part 4: Location-Based MFA Policy

This policy requires MFA for sign-ins from locations outside the trusted office network.

### Step 4.1 — Create the policy

1. In Conditional Access, click **+ New policy**
1. **Name:** `CA-03: Require MFA from Untrusted Locations`

### Step 4.2 — Configure Assignments

1. **Users:** `grp-sc500-contributors` (target the developer group)

1. **Target resources:** Select specific apps → **Microsoft Azure Management**

1. **Conditions** → **Locations**:
   - **Include:** Any location
   - **Exclude:** Trusted Office Network (named location created in Part 1)
   - Click **Done**

### Step 4.3 — Configure Access Controls

1. **Grant**: **Grant access** + **Require multifactor authentication**

1. **Enable policy**: **Report-only**

1. Click **Create**

---

## Part 5: Verify and Review

### Step 5.1 — View all Conditional Access policies

1. In Conditional Access → **Policies**
1. ✅ You should see three policies:
   - CA-01: Require MFA for Administrators
   - CA-02: Block Legacy Authentication
   - CA-03: Require MFA from Untrusted Locations

### Step 5.2 — Check What If tool

Use the "What If" tool to simulate policy evaluation:

1. In Conditional Access, click **What If**
1. Fill in:
   - **User:** `alice-admin@yourtenant.onmicrosoft.com`
   - **Cloud app:** Microsoft Azure Management
   - **IP address:** (leave blank for current location)
1. Click **What If**
1. ✅ Review which policies would apply and what controls would be enforced

---

## ARM Template Deployment

Conditional Access policies are configured via Microsoft Graph API, not ARM templates. However, the `templates/conditional-access-policy.json` file in this lab provides a reference configuration.

```powershell
# Deploy using Microsoft Graph PowerShell
Install-Module -Name Microsoft.Graph -Force
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

# Create MFA for admins policy (example)
$policy = @{
    displayName = "CA-01: Require MFA for Administrators"
    state = "enabledForReportingButNotEnforced"
    conditions = @{
        users = @{
            includeRoles = @("62e90394-69f5-4237-9190-012177145e10")  # Global Administrator
        }
        applications = @{
            includeApplications = @("All")
        }
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("mfa")
    }
}
New-MgIdentityConditionalAccessPolicy -BodyParameter $policy
```

---

## Equivalent Az CLI Commands

```bash
# View existing Conditional Access policies (requires Graph extension)
az ad conditional-access policy list --query "[].{Name:displayName, State:state}" -o table
```

---

## Validation Steps

```powershell
# List Conditional Access policies via Graph API
Connect-MgGraph -Scopes "Policy.Read.ConditionalAccess"
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State | Format-Table
```

Expected output:

```text
DisplayName                                  State
-----------                                  -----
CA-01: Require MFA for Administrators        enabledForReportingButNotEnforced
CA-02: Block Legacy Authentication           enabledForReportingButNotEnforced
CA-03: Require MFA from Untrusted Locations  enabledForReportingButNotEnforced
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Conditional Access menu not visible | Entra ID P1/P2 not licensed | Assign a P1 or P2 license to users; activate trial |
| Policy not evaluating | User not in scope | Check users/groups assignment in policy |
| Locked out after enabling MFA policy | No MFA method registered | Use break-glass account or disable policy via Graph API |
| Legacy auth still working | Policy in report-only mode | Switch to Enabled after testing |

**Break-glass recovery:**

```powershell
# Disable a policy via Graph API if locked out
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"
$policy = Get-MgIdentityConditionalAccessPolicy | Where-Object { $_.DisplayName -eq "CA-01: Require MFA for Administrators" }
Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policy.Id -State "disabled"
```

---

## Cleanup Instructions

To remove the Conditional Access policies:

1. Navigate to Conditional Access → Policies
1. Click each policy → Edit → **Enable policy:** Off → Save
1. Then delete the policy: Edit → Delete

Or via PowerShell:

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"
$policiesToDelete = @("CA-01: Require MFA for Administrators", "CA-02: Block Legacy Authentication", "CA-03: Require MFA from Untrusted Locations")
foreach ($name in $policiesToDelete) {
    $policy = Get-MgIdentityConditionalAccessPolicy | Where-Object { $_.DisplayName -eq $name }
    if ($policy) {
        Remove-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policy.Id
        Write-Host "Deleted: $name"
    }
}
```

---

## Key Takeaways

- Always start Conditional Access policies in **report-only** mode
- **Block legacy authentication** is a high-impact, quick-win security control
- Use **named locations** to differentiate trusted vs untrusted networks
- The **What If** tool is essential for testing policy impact without affecting users
- Conditional Access requires **Entra ID P1 or P2** licensing
