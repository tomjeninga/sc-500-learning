# Lab 02: Azure SQL Database Security

## Overview

**Estimated Time:** 60–90 minutes  
**Estimated Cost:** ~$5–10 (Azure SQL Database Basic tier at ~$5/month pro-rated; ~$0.16/hr. Delete after lab.)  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will deploy an Azure SQL Database with TDE enabled (using Microsoft-managed keys), configure Entra ID authentication, set up firewall rules, enable auditing to Log Analytics, configure Defender for SQL, and classify sensitive data columns.

**Why this matters:**
- SQL security is tested on SC-500 across multiple angles: TDE, auth, auditing, Defender
- Understanding which control protects against which threat is exam-critical
- Data classification (sensitivity labels) is increasingly tested as organizations adopt Purview

---

> **Depends on:** `rg-sc500-lab` and optionally `03-security-operations/lab-02-sentinel-setup.md` if you want to reuse `law-sc500-sentinel` for audit logs
> **Reused by:** `02-platform-protection/lab-03-private-access-patterns.md`
> **Delete after:** you finish private endpoint validation or any SQL auditing review that still uses this server

## Prerequisites

- `rg-sc500-lab` resource group
- Contributor role on `rg-sc500-lab`
- Optional: Log Analytics workspace `law-sc500-sentinel` from Module 3 if you want to reuse an existing workspace for audit logs

---

## Part 1: Create Azure SQL Server and Database

### Step 1.1 — Create SQL Server

1. Search for **SQL servers** → **+ Create**
2. **Basics:**
   - **Resource group:** `rg-sc500-lab`
   - **Server name:** `sql-sc500-lab-<suffix>` (globally unique, lowercase)
   - **Region:** East US
   - **Authentication method:** Use only Microsoft Entra authentication
   - **Microsoft Entra admin:** Click **Set admin** → select your account (or alice-admin if created)
3. Click **Next: Networking**

### Step 1.2 — Configure Networking

4. **Connectivity method:** No access (private only for production; we'll add an exception)
5. For lab purposes:
   - **Allow Azure services and resources to access this server:** Yes
   - **Add current client IP address:** Yes
6. Click **Review + create** → **Create**

---

## Part 2: Create the Database

### Step 2.1 — Create database

1. Open your SQL server → **+ Create database**
2. **Basics:**
   - **Database name:** `sqldb-sc500-lab`
   - **Compute + storage:** Click **Configure database**
     - **Service tier:** General Purpose (Serverless) or Basic
     - **Max vCores:** 1
     - **Autopause delay:** 1 hour (saves cost when idle)
3. Click **Review + create** → **Create**

---

## Part 3: Verify TDE is Enabled

### Step 3.1 — Check TDE status

1. Open `sqldb-sc500-lab`
2. In the left menu, click **Transparent data encryption**
3. ✅ TDE should show as **Enabled** with **Service-managed key** (PMK)

### Step 3.2 — (Optional) Switch to CMK

To use Customer-Managed Keys:
1. In TDE settings, select **Customer-managed key**
2. Select Key Vault: `kv-sc500-lab`
3. Select key: `storage-cmk-key` (reuse from Lab 01, or create a new one)
4. Check **Auto-rotate key** (recommended)
5. Click **Save**

---

## Part 4: Configure Entra ID Authentication

### Step 4.1 — Connect to database using Entra ID

Test connecting with your Entra ID account:

```powershell
# Install SqlServer module if needed
Install-Module -Name SqlServer -Force

# Connect using Entra ID (interactive MFA)
$connection = @{
    ServerInstance  = "sql-sc500-lab-<suffix>.database.windows.net"
    Database        = "sqldb-sc500-lab"
    AccessToken     = (Get-AzAccessToken -ResourceUrl "https://database.windows.net/").Token
}
Invoke-Sqlcmd @connection -Query "SELECT SYSTEM_USER, USER_NAME(), @@VERSION"
```

### Step 4.2 — Create a contained database user from Entra ID

```sql
-- Run this in the database as Entra ID admin
CREATE USER [alice-admin@yourtenant.onmicrosoft.com] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [alice-admin@yourtenant.onmicrosoft.com];
```

---

## Part 5: Enable SQL Auditing

### Step 5.1 — Configure auditing

1. Open your SQL server → **Auditing**
2. Toggle **Azure SQL Auditing** to **On**
3. **Audit log destination:**
   - Check **Log Analytics**
   - Select one of these options:
     - Reuse `law-sc500-sentinel` if you already completed the Sentinel lab
     - Or create/select a small dedicated workspace such as `law-sc500-sql`
4. Click **Save**

### Step 5.2 — Verify audit logs appear

After a few minutes:
1. Open the Log Analytics workspace you selected for auditing → **Logs**
2. Run:
```kql
AzureDiagnostics
| where ResourceType == "SERVERS/DATABASES"
| where Category == "SQLSecurityAuditEvents"
| project TimeGenerated, server_instance_name_s, database_name_s, action_name_s, succeeded_s, client_ip_s
| order by TimeGenerated desc
| take 20
```

---

## Part 6: Enable Defender for SQL

### Step 6.1 — Enable Defender for SQL on the database

1. Open `sqldb-sc500-lab` → **Microsoft Defender for Cloud**
2. Click **Enable Microsoft Defender for SQL**
3. ✅ Defender for SQL enables:
   - Advanced Threat Protection (SQL injection detection, anomalous access)
   - Vulnerability Assessment

### Step 6.2 — Run Vulnerability Assessment

4. Click **Vulnerability assessment**
5. **Configure storage account** for scan results (create or select a storage account)
6. Click **Scan**
7. Review findings — common findings in a new database:
   - "Email notifications are not configured for subscription owners" (severity: medium)
   - "Auditing of critical database activities is not configured" (if not done in Part 5)

---

## Part 7: Data Classification

### Step 7.1 — Discover sensitive columns

1. Open `sqldb-sc500-lab` → **Data Discovery & Classification**
2. Defender for SQL scans the schema and recommends classifications
3. If you have no tables yet, the scanner will show no recommendations
4. For a realistic test, create a table first:

```sql
-- Create a sample table with sensitive data columns
CREATE TABLE CustomerData (
    CustomerID   INT PRIMARY KEY IDENTITY,
    FirstName    NVARCHAR(50),
    LastName     NVARCHAR(50),
    Email        NVARCHAR(100),
    CreditCard   NVARCHAR(20),
    SSN          NVARCHAR(11),
    BirthDate    DATE
);
```

5. Re-scan in Data Discovery & Classification
6. ✅ Columns like `CreditCard`, `SSN`, `Email` should be flagged with recommended sensitivity labels

### Step 7.2 — Apply sensitivity labels

7. In the classification recommendations, click **Accept all recommendations**
8. Click **Save**
9. ✅ Columns are now labeled — any Defender for SQL alerts about these columns will include the classification context

> **Keep for later labs:** Keep this SQL server alive if you plan to do `02-platform-protection/lab-03-private-access-patterns.md`, which reuses it for private endpoint testing.

---

## ARM Template Deployment

```bash
az deployment group create \
  --resource-group rg-sc500-lab \
  --template-file templates/sql-database-secured.json \
  --parameters sqlServerName=sql-sc500-lab-<suffix> sqlAdminObjectId=<entra-user-object-id>
```

```powershell
$adminId = (Get-AzADUser -SignedIn).Id
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sc500-lab" `
  -TemplateFile ".\templates\sql-database-secured.json" `
  -sqlServerName "sql-sc500-lab-<suffix>" `
  -sqlAdminObjectId $adminId
```

---

## Validation Steps

```powershell
$rg = "rg-sc500-lab"
$serverName = "sql-sc500-lab-<suffix>"

# Verify SQL server exists with Entra-only auth
$server = Get-AzSqlServer -ResourceGroupName $rg -ServerName $serverName
Write-Host "Authentication: $($server.MinimalTlsVersion)"
Write-Host "Microsoft Entra-only auth (AzureADOnlyAuthentication): $($server.Administrators.AzureADOnlyAuthentication)"

# Verify TDE
$tde = Get-AzSqlDatabaseTransparentDataEncryption -ResourceGroupName $rg -ServerName $serverName -DatabaseName "sqldb-sc500-lab"
Write-Host "TDE Status: $($tde.State)"

# Check Defender for SQL
$atps = Get-AzSqlServerAdvancedThreatProtectionPolicy -ResourceGroupName $rg -ServerName $serverName
Write-Host "Advanced Threat Protection: $($atps.IsEnabled)"
```

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Cannot connect with Entra ID | Server blocks public access | Add client IP in SQL server firewall rules |
| Entra auth fails | Not set as Entra admin | Set Entra admin on SQL server before connecting |
| Audit logs not appearing | Log Analytics delay | Wait 15 minutes; verify diagnostic setting saved |
| Defender scan fails | No storage account configured | Configure a storage account for scan results first |

---

## Cleanup Instructions

```powershell
$rg = "rg-sc500-lab"
$serverName = "sql-sc500-lab-<suffix>"

# Delete database first, then server
Remove-AzSqlDatabase -ResourceGroupName $rg -ServerName $serverName -DatabaseName "sqldb-sc500-lab" -Force
Remove-AzSqlServer -ResourceGroupName $rg -ServerName $serverName -Force

Write-Host "SQL resources deleted."
```

---

## Key Takeaways

- TDE is **enabled by default** on Azure SQL — it protects data at rest from physical storage access
- **Entra ID-only authentication** eliminates SQL usernames/passwords — use Managed Identity for apps
- SQL Auditing → Log Analytics enables KQL queries on access patterns in Sentinel
- **Defender for SQL** provides threat detection (SQL injection) AND vulnerability assessment
- Data classification labels flow into Defender alerts and Purview data catalog
- Always Encrypted (not covered in portal steps) protects individual columns even from DBAs
