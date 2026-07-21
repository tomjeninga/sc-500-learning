# Lab 02: WAF Setup — Application Gateway v2 with WAF_v2

## Overview

**Estimated Time:** 90–120 minutes  
**Estimated Cost:** ~$5–10 (App Gateway WAF_v2 for ~3 hours; delete after lab)  
**Difficulty:** Intermediate–Advanced

> ⚠️ **Cost Note:** Application Gateway WAF_v2 costs approximately $0.246/hour + capacity units. Delete the App Gateway promptly after this lab to avoid costs.

---

## What You'll Build and WHY

You will deploy an Application Gateway v2 with WAF_v2 in Prevention mode, configure the OWASP 3.2 ruleset, add a custom rate-limiting rule, and simulate attack patterns to verify detection.

**Why this matters:**

- WAF is a primary defence against OWASP Top 10 web attacks
- SC-500 tests WAF modes, rulesets, and when to use WAF vs Firewall vs NSG
- You'll see exactly how WAF logs look — useful for real incident response

**Architecture:**

```text
Internet
    │
    ▼
[Application Gateway v2 WAF_v2]
    │  - OWASP 3.2 ruleset enabled
    │  - Prevention mode
    │  - Custom rule: block if more than 100 req/min from one IP
    │
    ▼
[Backend pool: test VM in snet-frontend]
```

---

## Prerequisites

- Completed Lab 01 (`vnet-sc500-lab` and subnets exist)
- `rg-sc500-lab` resource group
- A test VM or App Service as backend (or use the App Gateway's default backend page)

---

## Part 1: Create a WAF Policy

It is best practice to create a WAF Policy resource first, then attach it to the App Gateway.

### Step 1.1 — Create WAF Policy

1. Search for **Web Application Firewall policies (WAF)** → **+ Create**
1. **Basics:**
   - **Policy for:** Regional WAF (Application Gateway)
   - **Subscription:** Your subscription
   - **Resource group:** `rg-sc500-lab`
   - **Policy name:** `waf-policy-sc500`
   - **Location:** East US
1. Click **Next: Policy settings**

### Step 1.2 — Configure WAF Policy Settings

1. **Policy mode:** Prevention
1. **Inspect request body:** Enabled
1. **Max request body size (KB):** 128
1. **File upload limit (MB):** 100
1. Click **Next: Managed rules**

### Step 1.3 — Configure Managed Rules

1. **Managed rule set:** OWASP 3.2
1. Leave all rule groups enabled (default)
1. Click **Next: Custom rules**

### Step 1.4 — Add a Custom Rate-Limiting Rule

 1. Click **+ Add custom rule**
 1. Configure:
    - **Custom rule name:** `BlockHighRequestRate`
    - **Status:** Enabled
    - **Rule type:** Rate limit
    - **Rate limit duration:** 1 minute
    - **Rate limit threshold:** 100
    - **Conditions:** (add if needed) Request URI → Contains → `/`
    - **Action:** Block
 1. Click **Add**
 1. Click **Next: Association** → **Next: Tags** → **Review + create** → **Create**

---

## Part 2: Deploy Application Gateway v2

### Step 2.1 — Create App Gateway

1. Search for **Application gateways** → **+ Create**
1. **Basics:**
   - **Resource group:** `rg-sc500-lab`
   - **Name:** `agw-sc500-waf`
   - **Region:** East US
   - **Tier:** WAF V2
   - **Enable autoscaling:** No (set Min: 1, Max: 1 for lab cost control)
   - **Availability zone:** None
1. Click **Next: Frontends**

### Step 2.2 — Configure Frontend

1. **Frontend IP address type:** Public
1. **Public IP address:** Create new → Name: `pip-agw-sc500` → OK
1. Click **Next: Backends**

### Step 2.3 — Configure Backend Pool

1. Click **+ Add a backend pool**
1. Configure:
   - **Name:** `backend-pool-01`
   - **Add backend pool without targets:** Yes (for now — we'll use the default page)
1. Click **Add**
1. Click **Next: Configuration**

### Step 2.4 — Configure Routing Rules

 1. Click **+ Add a routing rule**
 1. **Rule name:** `rule-http-to-backend`
 1. **Priority:** 100
 1. **Listener:**
    - **Listener name:** `listener-http`
    - **Frontend IP:** Public
    - **Port:** 80
    - **Protocol:** HTTP
 1. **Backend targets:**
    - **Target type:** Backend pool
    - **Backend target:** backend-pool-01
    - **Backend settings:** Add new:
      - Name: `settings-http`
      - Protocol: HTTP
      - Port: 80
 1. Click **Add** → **Next: Tags** → **Next: Review + create** → **Create**

> Deployment takes approximately 10 minutes.

### Step 2.5 — Associate WAF Policy with App Gateway

Once App Gateway is deployed:

1. Open `agw-sc500-waf` → **Web application firewall**
1. Under WAF Policy, select `waf-policy-sc500`
1. Click **Save**

---

## Part 3: Configure Diagnostic Logs

Enable logging to track WAF-blocked requests.

### Step 3.1 — Enable diagnostics

1. Open `agw-sc500-waf` → **Diagnostic settings** → **+ Add diagnostic setting**
1. **Name:** `diag-agw-sc500`
1. Check:
   - **ApplicationGatewayAccessLog**
   - **ApplicationGatewayFirewallLog**
1. **Destination:** Send to Log Analytics workspace
   - Create new workspace: `law-sc500-waf` (or use existing)
1. Click **Save**

---

## Part 4: Simulate Attack Traffic

### Step 4.1 — Get the App Gateway public IP

```powershell
$pip = Get-AzPublicIpAddress -Name "pip-agw-sc500" -ResourceGroupName "rg-sc500-lab"
$appGwIp = $pip.IpAddress
Write-Host "App Gateway IP: $appGwIp"
```

### Step 4.2 — Simulate a SQL Injection attempt

```bash
# Simulate SQL injection in URL parameter (should be blocked in Prevention mode)
curl "http://$appGwIp/?id=1' OR '1'='1"

# Expected response: 403 Forbidden
```

### Step 4.3 — Simulate an XSS attempt

```bash
# Simulate XSS attack (should be blocked)
curl "http://$appGwIp/?search=<script>alert('xss')</script>"

# Expected response: 403 Forbidden
```

### Step 4.4 — Review WAF Logs

1. Open the Log Analytics workspace `law-sc500-waf`
1. Click **Logs** and run this KQL query:

```kql
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS"
| where Category == "ApplicationGatewayFirewallLog"
| where action_s == "Blocked"
| project TimeGenerated, clientIp_s, requestUri_s, ruleGroup_s, ruleId_s, message_s
| order by TimeGenerated desc
| take 20
```

1. ✅ You should see log entries for the blocked SQLi and XSS attempts

---

## ARM Template Deployment

```bash
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/app-gateway-waf.json \
  --parameters appGatewayName=agw-sc500-waf vnetName=vnet-sc500-lab
```

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\app-gateway-waf.json" `
  -appGatewayName "agw-sc500-waf" `
  -vnetName "vnet-sc500-lab"
```

---

## Validation Steps

```powershell
# Check App Gateway operational state
$agw = Get-AzApplicationGateway -Name "agw-sc500-waf" -ResourceGroupName "rg-sc500-lab"
Write-Host "State: $($agw.OperationalState)"
Write-Host "SKU: $($agw.Sku.Name) - $($agw.Sku.Tier)"
Write-Host "WAF Enabled: $($agw.WebApplicationFirewallConfiguration.Enabled)"
Write-Host "WAF Mode: $($agw.WebApplicationFirewallConfiguration.FirewallMode)"

# Verify WAF policy association
Write-Host "WAF Policy: $($agw.FirewallPolicy.Id.Split('/')[-1])"
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| 403 on legitimate traffic | WAF rule false positive | Switch policy to Detection mode, identify rule, add exclusion |
| App Gateway not responding | Backend pool is empty/unhealthy | Check backend health probe in App Gateway → Backend health |
| WAF logs not appearing | Diagnostic settings delay | Wait 5–10 min; logs have up to 3-min delay |
| Deployment fails with subnet error | Subnet doesn't exist or is too small | Ensure `snet-frontend` exists in VNet |

**Switch WAF to Detection mode (troubleshooting):**

1. WAF Policy → Policy settings → Mode → Detection → Save

---

## Cleanup Instructions

> ⚠️ Delete the App Gateway promptly — it's the most expensive resource in this lab.

```powershell
$rg = "rg-sc500-lab"

# Delete App Gateway first (takes ~5 min)
Remove-AzApplicationGateway -Name "agw-sc500-waf" -ResourceGroupName $rg -Force

# Delete public IP
Remove-AzPublicIpAddress -Name "pip-agw-sc500" -ResourceGroupName $rg -Force

# Delete WAF policy
Remove-AzApplicationGatewayFirewallPolicy -Name "waf-policy-sc500" -ResourceGroupName $rg -Force

# Delete Log Analytics workspace
Remove-AzOperationalInsightsWorkspace -Name "law-sc500-waf" -ResourceGroupName $rg -Force
```

---

## Key Takeaways

- WAF Policy is a separate resource — you can attach it to multiple App Gateways
- Always start in **Detection mode** to tune before switching to Prevention
- OWASP 3.2 is the current recommended managed ruleset
- WAF custom rules provide rate limiting and geo-filtering beyond OWASP
- Review `ApplicationGatewayFirewallLog` in Log Analytics for blocked requests
- App Gateway WAF protects against **application layer (L7)** attacks; NSGs protect Layer 4
