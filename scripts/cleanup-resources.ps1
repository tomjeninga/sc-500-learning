<#
.SYNOPSIS
    Safely deletes all resources in the rg-sc500-lab resource group.

.DESCRIPTION
    This script removes all Azure resources created during the SC-500 learning
    labs. It presents a summary of resources to be deleted and requires
    explicit confirmation before proceeding.

    Resources deleted:
    - All resources in rg-sc500-lab resource group
    - Entra ID test users created for labs (optional)
    - Entra ID security groups created for labs (optional)

    Resources NOT deleted (to avoid unexpected charges):
    - Conditional Access policies (delete manually from Entra ID portal)
    - Policy assignments (deleted as part of RG cleanup)

.PARAMETER ResourceGroupName
    Name of the resource group to clean up. Default: rg-sc500-lab

.PARAMETER DeleteEntraIDObjects
    If specified, also deletes Entra ID test users and groups created by the labs.

.PARAMETER Force
    Skip confirmation prompt and delete immediately. USE WITH CAUTION.

.EXAMPLE
    .\cleanup-resources.ps1

.EXAMPLE
    .\cleanup-resources.ps1 -DeleteEntraIDObjects

.EXAMPLE
    .\cleanup-resources.ps1 -Force -DeleteEntraIDObjects

.NOTES
    SC-500 Learning Lab — Shared Cleanup Script
    WARNING: This PERMANENTLY deletes Azure resources. This action cannot be undone.
    Ensure you have exported any data or outputs you need before running.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()]
    [string]$ResourceGroupName = "rg-sc500-lab",

    [Parameter()]
    [switch]$DeleteEntraIDObjects,

    [Parameter()]
    [switch]$Force
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

function Write-Warn {
    param([string]$Message)
    Write-Host "    ⚠ $Message" -ForegroundColor Yellow
}

#region Pre-flight

Write-Step "Pre-flight checks..."

# Verify Az module
if (-not (Get-Module -Name Az.Accounts -ListAvailable)) {
    throw "Az PowerShell module not found. Install with: Install-Module -Name Az -Force"
}

# Verify connection
$context = Get-AzContext
if (-not $context) {
    throw "Not connected to Azure. Run: Connect-AzAccount"
}
Write-Success "Connected as: $($context.Account.Id)"
Write-Success "Subscription: $($context.Subscription.Name)"

# Verify resource group exists
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Warn "Resource group '$ResourceGroupName' not found. Nothing to clean up."
    exit 0
}

#endregion

#region Display Resources

Write-Step "Resources in '$ResourceGroupName' to be deleted:"

$resources = Get-AzResource -ResourceGroupName $ResourceGroupName
if ($resources.Count -eq 0) {
    Write-Warn "No resources found in '$ResourceGroupName'."
} else {
    $resources | Format-Table Name, ResourceType, Location -AutoSize
    Write-Host "`n    Total: $($resources.Count) resource(s)" -ForegroundColor Yellow
}

# Show Defender for Cloud paid plans if enabled
Write-Host "`n    Note: Paid Defender for Cloud plans will NOT be automatically disabled." -ForegroundColor Yellow
Write-Host "          Run: Set-AzSecurityPricing -Name 'VirtualMachines' -PricingTier 'Free' to disable." -ForegroundColor Yellow

#endregion

#region Confirmation

if (-not $Force) {
    Write-Host "`n" + ("=" * 60) -ForegroundColor Red
    Write-Host "  WARNING: This will PERMANENTLY DELETE all resources in" -ForegroundColor Red
    Write-Host "  '$ResourceGroupName'. This action CANNOT be undone." -ForegroundColor Red
    Write-Host ("=" * 60) -ForegroundColor Red

    $confirmation = Read-Host "`nType 'DELETE' to confirm (or anything else to cancel)"
    if ($confirmation -ne "DELETE") {
        Write-Host "`nCleanup cancelled. No resources were deleted." -ForegroundColor Green
        exit 0
    }
}

#endregion

#region Delete Resource Group

Write-Step "Deleting resource group '$ResourceGroupName' and all resources..."

try {
    if ($PSCmdlet.ShouldProcess($ResourceGroupName, "Delete resource group")) {
        # Disable Defender for Servers plan first to stop billing
        try {
            Set-AzSecurityPricing -Name "VirtualMachines" -PricingTier "Free" -ErrorAction SilentlyContinue | Out-Null
            Write-Success "Defender for Servers plan set to Free"
        } catch {
            Write-Warn "Could not disable Defender for Servers: $_"
        }

        # Remove policy assignments first (they block RG deletion in some cases)
        $scope = "/subscriptions/$($context.Subscription.Id)/resourceGroups/$ResourceGroupName"
        $assignments = Get-AzPolicyAssignment -Scope $scope -ErrorAction SilentlyContinue
        foreach ($assignment in $assignments) {
            try {
                Remove-AzPolicyAssignment -Id $assignment.ResourceId -ErrorAction SilentlyContinue
                Write-Success "Removed policy assignment: $($assignment.Properties.DisplayName)"
            } catch {
                Write-Warn "Could not remove policy assignment: $($assignment.Properties.DisplayName)"
            }
        }

        # Delete the resource group (deletes all resources inside)
        Write-Host "    Deleting resource group... (this may take a few minutes)" -ForegroundColor Cyan
        Remove-AzResourceGroup -Name $ResourceGroupName -Force -ErrorAction Stop

        Write-Success "Resource group '$ResourceGroupName' deleted successfully."
    }
} catch {
    Write-Host "    Error deleting resource group: $_" -ForegroundColor Red
    Write-Host "    Try deleting manually in the Azure Portal." -ForegroundColor Yellow
    exit 1
}

#endregion

#region Delete Entra ID Objects (Optional)

if ($DeleteEntraIDObjects) {
    Write-Step "Deleting Entra ID test objects..."

    $labUserUpnPrefixes = @("alice-admin", "bob-security", "charlie-dev", "testuser01", "testuser02", "testuser03")
    $labGroupNames      = @("grp-sc500-security-readers", "grp-sc500-contributors")

    # Get tenant domain for UPN construction
    $tenant = Get-AzTenant -TenantId $context.Tenant.Id
    $tenantDomain = $tenant.Domains | Select-Object -First 1

    # Remove users
    Write-Host "`n    Removing test users..." -ForegroundColor Cyan
    foreach ($upnPrefix in $labUserUpnPrefixes) {
        $upn = "$upnPrefix@$tenantDomain"
        try {
            $user = Get-AzADUser -UserPrincipalName $upn -ErrorAction SilentlyContinue
            if ($user) {
                if ($PSCmdlet.ShouldProcess($upn, "Delete Entra ID user")) {
                    Remove-AzADUser -UPNOrObjectId $upn -ErrorAction Stop
                    Write-Success "Deleted user: $upn"
                }
            } else {
                Write-Warn "User not found: $upn (already deleted or never created)"
            }
        } catch {
            Write-Host "    Error deleting user '$upn': $_" -ForegroundColor Red
        }
    }

    # Remove groups
    Write-Host "`n    Removing security groups..." -ForegroundColor Cyan
    foreach ($groupName in $labGroupNames) {
        try {
            $group = Get-AzADGroup -DisplayName $groupName -ErrorAction SilentlyContinue
            if ($group) {
                if ($PSCmdlet.ShouldProcess($groupName, "Delete Entra ID group")) {
                    Remove-AzADGroup -ObjectId $group.Id -ErrorAction Stop
                    Write-Success "Deleted group: $groupName"
                }
            } else {
                Write-Warn "Group not found: $groupName (already deleted or never created)"
            }
        } catch {
            Write-Host "    Error deleting group '$groupName': $_" -ForegroundColor Red
        }
    }
}

#endregion

#region Purge Soft-Deleted Key Vaults (Optional)

Write-Step "Checking for soft-deleted Key Vaults..."

try {
    $deletedVaults = Get-AzKeyVault -InRemovedState -ErrorAction SilentlyContinue |
        Where-Object { $_.ResourceId -like "*$ResourceGroupName*" }

    if ($deletedVaults) {
        Write-Warn "$($deletedVaults.Count) soft-deleted Key Vault(s) found:"
        $deletedVaults | ForEach-Object { Write-Host "    - $($_.VaultName)" -ForegroundColor Yellow }
        Write-Host "`n    These will be automatically purged after the soft-delete retention period."
        Write-Host "    To purge immediately (permanent): Remove-AzKeyVault -VaultName '<name>' -InRemovedState -Force"
    } else {
        Write-Success "No soft-deleted Key Vaults found."
    }
} catch {
    Write-Warn "Could not check for soft-deleted Key Vaults: $_"
}

#endregion

#region Summary

Write-Host "`n" + ("=" * 60) -ForegroundColor Green
Write-Host "Cleanup Complete!" -ForegroundColor Green
Write-Host ("=" * 60) -ForegroundColor Green

Write-Host "`nDeleted:"
Write-Host "  ✓ Resource group: $ResourceGroupName (and all contained resources)"

if ($DeleteEntraIDObjects) {
    Write-Host "  ✓ Entra ID test users and groups"
}

Write-Host "`nReminder — manual cleanup still required for:"
Write-Host "  - Conditional Access policies (Entra ID → Security → Conditional Access)"
Write-Host "  - Soft-deleted Key Vaults (if purge protection is disabled)"
Write-Host "  - Budget alerts (Cost Management → Budgets)"
Write-Host "  - Log Analytics workspaces (if not in deleted RG)"
Write-Host ""

#endregion
