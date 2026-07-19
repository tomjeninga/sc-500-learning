<#
.SYNOPSIS
    Creates bulk test users in Microsoft Entra ID for SC-500 labs.

.DESCRIPTION
    Creates multiple test user accounts in Entra ID, assigns them to
    security groups, and outputs a CSV with credentials.

    This script is idempotent — re-running it will skip existing users.

.PARAMETER TenantDomain
    Your Entra ID tenant domain (e.g., contoso.onmicrosoft.com).
    If not specified, auto-detected from current Az context.

.PARAMETER CsvOutputPath
    Path to save the generated user credentials CSV. Default: /tmp/lab-users.csv

.PARAMETER UserCount
    Number of extra generic test users to create (in addition to named lab users). Default: 3

.EXAMPLE
    .\create-test-users.ps1

.EXAMPLE
    .\create-test-users.ps1 -TenantDomain "myorg.onmicrosoft.com" -UserCount 5

.NOTES
    SC-500 Learning Lab — Domain 1: Identity & Governance
    WARNING: Credentials are written to a CSV — delete it when done.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()]
    [string]$TenantDomain = "",

    [Parameter()]
    [string]$CsvOutputPath = "/tmp/lab-users.csv",

    [Parameter()]
    [int]$UserCount = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "    ✓ $Message" -ForegroundColor Green
}

function New-RandomPassword {
    $upper   = "ABCDEFGHJKLMNPQRSTUVWXYZ"
    $lower   = "abcdefghijkmnpqrstuvwxyz"
    $digits  = "23456789"
    $special = "!@#$%^&*"

    $pwd = ""
    $pwd += $upper[(Get-Random -Maximum $upper.Length)]
    $pwd += $lower[(Get-Random -Maximum $lower.Length)]
    $pwd += $digits[(Get-Random -Maximum $digits.Length)]
    $pwd += $special[(Get-Random -Maximum $special.Length)]

    $allChars = $upper + $lower + $digits + $special
    for ($i = 0; $i -lt 12; $i++) {
        $pwd += $allChars[(Get-Random -Maximum $allChars.Length)]
    }

    # Shuffle
    return -join ($pwd.ToCharArray() | Sort-Object { Get-Random })
}

#region Pre-flight

Write-Step "Checking prerequisites..."

if (-not (Get-Module -Name Az.Accounts -ListAvailable)) {
    throw "Az PowerShell module not found. Install with: Install-Module -Name Az -Force"
}

$context = Get-AzContext
if (-not $context) {
    throw "Not connected to Azure. Run: Connect-AzAccount"
}
Write-Success "Connected as: $($context.Account.Id)"

if ([string]::IsNullOrEmpty($TenantDomain)) {
    $tenant = Get-AzTenant -TenantId $context.Tenant.Id
    $TenantDomain = $tenant.Domains | Select-Object -First 1
    Write-Success "Auto-detected tenant domain: $TenantDomain"
}

#endregion

#region Define Users

Write-Step "Preparing user definitions..."

# Named lab users
$labUsers = @(
    @{ DisplayName = "Alice Admin";       UPN = "alice-admin";    JobTitle = "Security Administrator"; Dept = "IT Security" },
    @{ DisplayName = "Bob Security";      UPN = "bob-security";   JobTitle = "SOC Analyst";            Dept = "IT Security" },
    @{ DisplayName = "Charlie Developer"; UPN = "charlie-dev";    JobTitle = "Platform Engineer";      Dept = "Engineering" }
)

# Generic test users
for ($i = 1; $i -le $UserCount; $i++) {
    $labUsers += @{
        DisplayName = "Test User $i"
        UPN         = "testuser$('{0:D2}' -f $i)"
        JobTitle    = "Test Account"
        Dept        = "Lab"
    }
}

#endregion

#region Create Users

Write-Step "Creating $($labUsers.Count) users in tenant: $TenantDomain..."

$results = @()

foreach ($userDef in $labUsers) {
    $upn = "$($userDef.UPN)@$TenantDomain"
    $password = New-RandomPassword

    try {
        $existing = Get-AzADUser -UserPrincipalName $upn -ErrorAction SilentlyContinue

        if ($existing) {
            Write-Host "    ⚠ User '$upn' already exists. Skipping." -ForegroundColor Yellow
            $results += [PSCustomObject]@{
                DisplayName = $userDef.DisplayName
                UPN         = $upn
                Password    = "(existing — not changed)"
                Status      = "Skipped"
            }
        } else {
            if ($PSCmdlet.ShouldProcess($upn, "Create user")) {
                $securePwd = ConvertTo-SecureString $password -AsPlainText -Force

                $userParams = @{
                    DisplayName       = $userDef.DisplayName
                    UserPrincipalName = $upn
                    MailNickname      = $userDef.UPN
                    AccountEnabled    = $true
                    JobTitle          = $userDef.JobTitle
                    Department        = $userDef.Dept
                    Password          = $securePwd
                }
                $newUser = New-AzADUser @userParams

                $results += [PSCustomObject]@{
                    DisplayName = $userDef.DisplayName
                    UPN         = $upn
                    Password    = $password
                    ObjectId    = $newUser.Id
                    Status      = "Created"
                }

                Write-Success "Created: $upn"
            }
        }
    } catch {
        Write-Host "    ✗ Error creating '$upn': $_" -ForegroundColor Red
        $results += [PSCustomObject]@{
            DisplayName = $userDef.DisplayName
            UPN         = $upn
            Password    = "N/A"
            Status      = "Error: $_"
        }
    }
}

#endregion

#region Output Results

Write-Step "Writing results to CSV: $CsvOutputPath"

try {
    $results | Export-Csv -Path $CsvOutputPath -NoTypeInformation -Encoding UTF8
    Write-Success "Credentials saved to: $CsvOutputPath"
    Write-Host "    ⚠ WARNING: Delete this file after noting the passwords!" -ForegroundColor Yellow
} catch {
    Write-Host "    Error writing CSV: $_" -ForegroundColor Red
}

# Summary
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "User Creation Summary" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan
$results | Format-Table DisplayName, UPN, Status -AutoSize

$created = ($results | Where-Object { $_.Status -eq "Created" }).Count
$skipped = ($results | Where-Object { $_.Status -eq "Skipped" }).Count
$errors  = ($results | Where-Object { $_.Status -like "Error*" }).Count

Write-Host "`nCreated: $created | Skipped: $skipped | Errors: $errors"
Write-Host "`nNext Step: Run setup-entra-id-lab.ps1 to assign roles."

#endregion
