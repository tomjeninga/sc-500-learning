<#
.SYNOPSIS
    Sets up the SC-500 lab environment for Domain 1: Identity & Governance.

.DESCRIPTION
    This script creates the Azure resource group and Entra ID resources needed
    for the identity governance labs. It creates test users, security groups,
    and assigns RBAC roles at resource group scope.

    Prerequisites:
    - Az PowerShell module installed
    - Connected to Azure via Connect-AzAccount
    - User Administrator or Global Administrator role in Entra ID
    - Owner or User Access Administrator role on the subscription

.PARAMETER ResourceGroupName
    The name of the resource group for lab resources. Default: rg-sc500-lab

.PARAMETER Location
    The Azure region for the resource group. Default: eastus

.PARAMETER TenantDomain
    Your Entra ID tenant domain (e.g., contoso.onmicrosoft.com).
    If not specified, auto-detected from current context.

.EXAMPLE
    .\setup-entra-id-lab.ps1 -ResourceGroupName "rg-sc500-lab" -Location "eastus"

.EXAMPLE
    .\setup-entra-id-lab.ps1 -TenantDomain "myorg.onmicrosoft.com"

.NOTES
    SC-500 Learning Lab — Domain 1: Identity & Governance
    Run cleanup-resources.ps1 to remove resources when done.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()]
    [string]$ResourceGroupName = "rg-sc500-lab",

    [Parameter()]
    [string]$Location = "eastus",

    [Parameter()]
    [string]$TenantDomain = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#region Helper Functions

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "    ✓ $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "    ⚠ $Message" -ForegroundColor Yellow
}

#endregion

#region Pre-flight Checks

Write-Step "Checking prerequisites..."

# Verify Az module
if (-not (Get-Module -Name Az -ListAvailable)) {
    throw "Az PowerShell module not found. Install with: Install-Module -Name Az -Force"
}

# Verify connection
try {
    $context = Get-AzContext
    if (-not $context) {
        throw "Not connected to Azure."
    }
    Write-Success "Connected as: $($context.Account.Id)"
    Write-Success "Subscription: $($context.Subscription.Name) ($($context.Subscription.Id))"
} catch {
    Write-Host "Please connect to Azure first: Connect-AzAccount" -ForegroundColor Red
    throw
}

# Get tenant domain if not specified
if ([string]::IsNullOrEmpty($TenantDomain)) {
    $tenant = Get-AzTenant -TenantId $context.Tenant.Id
    $TenantDomain = $tenant.Domains | Select-Object -First 1
    Write-Success "Auto-detected tenant domain: $TenantDomain"
}

#endregion

#region Resource Group

Write-Step "Creating resource group: $ResourceGroupName..."

try {
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if ($rg) {
        Write-Warn "Resource group '$ResourceGroupName' already exists. Skipping creation."
    } else {
        if ($PSCmdlet.ShouldProcess($ResourceGroupName, "Create resource group")) {
            $rg = New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{
                Purpose    = "SC-500 Learning Lab"
                Domain     = "01-Identity-Governance"
                AutoDelete = "true"
            }
            Write-Success "Resource group created: $ResourceGroupName in $Location"
        }
    }
} catch {
    Write-Host "Error creating resource group: $_" -ForegroundColor Red
    throw
}

#endregion

#region Entra ID Users

Write-Step "Creating Entra ID test users..."

$usersToCreate = @(
    @{ DisplayName = "Alice Admin";        UserPrincipalName = "alice-admin";     JobTitle = "Security Administrator"; Department = "IT Security" },
    @{ DisplayName = "Bob Security";       UserPrincipalName = "bob-security";    JobTitle = "SOC Analyst";            Department = "IT Security" },
    @{ DisplayName = "Charlie Developer";  UserPrincipalName = "charlie-dev";     JobTitle = "Platform Engineer";      Department = "Engineering" }
)

$createdUsers = @{}

foreach ($userDef in $usersToCreate) {
    $upn = "$($userDef.UserPrincipalName)@$TenantDomain"
    try {
        $existing = Get-AzADUser -UserPrincipalName $upn -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Warn "User '$upn' already exists. Skipping creation."
            $createdUsers[$userDef.UserPrincipalName] = $existing
        } else {
            if ($PSCmdlet.ShouldProcess($upn, "Create Entra ID user")) {
                # Generate a random initial password for the new user
                $chars   = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%"
                $initPwd = -join (1..16 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
                $securePwd = ConvertTo-SecureString $initPwd -AsPlainText -Force

                $userParams = @{
                    DisplayName       = $userDef.DisplayName
                    UserPrincipalName = $upn
                    MailNickname      = $userDef.UserPrincipalName
                    AccountEnabled    = $true
                    JobTitle          = $userDef.JobTitle
                    Department        = $userDef.Department
                    # Pass the secure string as the initial credential
                    Password          = $securePwd
                }
                $newUser = New-AzADUser @userParams

                $createdUsers[$userDef.UserPrincipalName] = $newUser
                Write-Success "Created user: $upn (Initial credential generated — check out-of-band)"
                Write-Host "       Note: User will be prompted to change credential on first sign-in." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "    Error creating user '$upn': $_" -ForegroundColor Red
    }
}

#endregion

#region Entra ID Groups

Write-Step "Creating Entra ID security groups..."

$groupsToCreate = @(
    @{
        DisplayName = "grp-sc500-security-readers"
        Description = "SC-500 lab — security reader access"
        Members     = @("bob-security")
    },
    @{
        DisplayName = "grp-sc500-contributors"
        Description = "SC-500 lab — contributor access"
        Members     = @("charlie-dev")
    }
)

$createdGroups = @{}

foreach ($groupDef in $groupsToCreate) {
    try {
        $existing = Get-AzADGroup -DisplayName $groupDef.DisplayName -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Warn "Group '$($groupDef.DisplayName)' already exists. Skipping creation."
            $createdGroups[$groupDef.DisplayName] = $existing
        } else {
            if ($PSCmdlet.ShouldProcess($groupDef.DisplayName, "Create security group")) {
                $newGroup = New-AzADGroup `
                    -DisplayName $groupDef.DisplayName `
                    -MailNickname $groupDef.DisplayName.Replace(" ", "-").ToLower() `
                    -Description $groupDef.Description `
                    -SecurityEnabled $true

                $createdGroups[$groupDef.DisplayName] = $newGroup
                Write-Success "Created group: $($groupDef.DisplayName)"

                # Add members
                foreach ($memberKey in $groupDef.Members) {
                    if ($createdUsers.ContainsKey($memberKey)) {
                        Start-Sleep -Seconds 2  # Allow replication
                        Add-AzADGroupMember -TargetGroupObjectId $newGroup.Id -MemberObjectId $createdUsers[$memberKey].Id
                        Write-Success "Added '$memberKey' to group '$($groupDef.DisplayName)'"
                    }
                }
            }
        }
    } catch {
        Write-Host "    Error creating group '$($groupDef.DisplayName)': $_" -ForegroundColor Red
    }
}

#endregion

#region RBAC Assignments

Write-Step "Assigning RBAC roles..."

$subscriptionId = $context.Subscription.Id
$rgScope = "/subscriptions/$subscriptionId/resourceGroups/$ResourceGroupName"

$roleAssignments = @(
    @{
        Scope      = $rgScope
        Role       = "Security Reader"
        PrincipalName = "grp-sc500-security-readers"
        PrincipalType = "Group"
    },
    @{
        Scope      = $rgScope
        Role       = "Contributor"
        PrincipalName = "grp-sc500-contributors"
        PrincipalType = "Group"
    }
)

foreach ($assignment in $roleAssignments) {
    try {
        $principal = if ($assignment.PrincipalType -eq "Group") {
            $createdGroups[$assignment.PrincipalName]
        } else {
            $createdUsers[$assignment.PrincipalName]
        }

        if (-not $principal) {
            Write-Warn "Skipping role assignment for '$($assignment.PrincipalName)' — principal not found."
            continue
        }

        $existingAssignment = Get-AzRoleAssignment `
            -ObjectId $principal.Id `
            -RoleDefinitionName $assignment.Role `
            -Scope $assignment.Scope `
            -ErrorAction SilentlyContinue

        if ($existingAssignment) {
            Write-Warn "Role '$($assignment.Role)' already assigned to '$($assignment.PrincipalName)'. Skipping."
        } else {
            if ($PSCmdlet.ShouldProcess("$($assignment.PrincipalName) -> $($assignment.Role)", "Assign role")) {
                New-AzRoleAssignment `
                    -ObjectId $principal.Id `
                    -RoleDefinitionName $assignment.Role `
                    -Scope $assignment.Scope | Out-Null
                Write-Success "Assigned '$($assignment.Role)' to '$($assignment.PrincipalName)' at scope: $($assignment.Scope)"
            }
        }
    } catch {
        Write-Host "    Error assigning role: $_" -ForegroundColor Red
    }
}

#endregion

#region Summary

Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "Lab Setup Complete!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan
Write-Host "`nResource Group:  $ResourceGroupName ($Location)"
Write-Host "Tenant Domain:   $TenantDomain"
Write-Host "`nUsers Created:"
foreach ($key in $createdUsers.Keys) {
    Write-Host "  - $key@$TenantDomain"
}
Write-Host "`nGroups Created:"
foreach ($key in $createdGroups.Keys) {
    Write-Host "  - $key"
}
Write-Host "`nNext Steps:"
Write-Host "  1. Open lab-01-entra-id-setup.md and verify resources in Azure Portal"
Write-Host "  2. Proceed to lab-02-conditional-access.md"
Write-Host "  3. Run cleanup-resources.ps1 when done"
Write-Host ""

#endregion
