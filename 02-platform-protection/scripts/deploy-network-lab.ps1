<#
.SYNOPSIS
    Deploys the SC-500 Domain 2 network security lab resources to Azure.

.DESCRIPTION
    Deploys a VNet with NSGs and optionally an Application Gateway with WAF_v2
    using ARM templates. Creates resources in the rg-sc500-lab resource group.

.PARAMETER ResourceGroupName
    Resource group name. Default: rg-sc500-lab

.PARAMETER Location
    Azure region. Default: eastus

.PARAMETER DeployWAF
    If specified, also deploys the Application Gateway WAF. Note: ~$0.25/hr cost.

.PARAMETER VNetOnly
    If specified, only deploys the VNet and NSGs (no App Gateway).

.EXAMPLE
    .\deploy-network-lab.ps1

.EXAMPLE
    .\deploy-network-lab.ps1 -DeployWAF -Location "westus2"

.NOTES
    SC-500 Learning Lab — Domain 2: Platform Protection
    Run cleanup-resources.ps1 to delete all resources when done.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()]
    [string]$ResourceGroupName = "rg-sc500-lab",

    [Parameter()]
    [string]$Location = "eastus",

    [Parameter()]
    [switch]$DeployWAF,

    [Parameter()]
    [switch]$VNetOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$TemplatesPath = Join-Path (Split-Path $ScriptRoot -Parent) "templates"

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "    ✓ $Message" -ForegroundColor Green
}

#region Pre-flight

Write-Step "Checking prerequisites..."

$context = Get-AzContext
if (-not $context) {
    throw "Not connected to Azure. Run: Connect-AzAccount"
}
Write-Success "Connected as: $($context.Account.Id)"

# Verify or create resource group
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    if ($PSCmdlet.ShouldProcess($ResourceGroupName, "Create resource group")) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{
            Purpose = "SC-500 Learning Lab"
            Domain  = "02-Platform-Protection"
        } | Out-Null
        Write-Success "Created resource group: $ResourceGroupName"
    }
} else {
    Write-Success "Resource group exists: $ResourceGroupName"
}

#endregion

#region Deploy VNet and NSGs

Write-Step "Deploying VNet with NSGs..."

$vnetTemplatePath = Join-Path $TemplatesPath "vnet-with-nsg.json"

if (-not (Test-Path $vnetTemplatePath)) {
    throw "Template not found: $vnetTemplatePath"
}

try {
    if ($PSCmdlet.ShouldProcess("VNet deployment", "Deploy ARM template")) {
        $vnetDeployment = New-AzResourceGroupDeployment `
            -ResourceGroupName $ResourceGroupName `
            -TemplateFile $vnetTemplatePath `
            -vnetName "vnet-sc500-lab" `
            -location $Location `
            -Mode Incremental `
            -Name "deploy-vnet-$(Get-Date -Format 'yyyyMMddHHmm')"

        if ($vnetDeployment.ProvisioningState -eq "Succeeded") {
            Write-Success "VNet deployment succeeded"
            Write-Host "    VNet ID: $($vnetDeployment.Outputs.vnetId.Value)"
        } else {
            throw "VNet deployment failed: $($vnetDeployment.ProvisioningState)"
        }
    }
} catch {
    Write-Host "    Error deploying VNet: $_" -ForegroundColor Red
    throw
}

#endregion

#region Deploy App Gateway WAF (optional)

if ($DeployWAF -and -not $VNetOnly) {
    Write-Step "Deploying Application Gateway WAF v2..."
    Write-Host "    ⚠ Note: App Gateway costs ~$0.25/hour. Remember to delete after lab!" -ForegroundColor Yellow

    $wafTemplatePath = Join-Path $TemplatesPath "app-gateway-waf.json"

    if (-not (Test-Path $wafTemplatePath)) {
        throw "WAF template not found: $wafTemplatePath"
    }

    try {
        if ($PSCmdlet.ShouldProcess("App Gateway WAF deployment", "Deploy ARM template")) {
            $wafDeployment = New-AzResourceGroupDeployment `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $wafTemplatePath `
                -appGatewayName "agw-sc500-waf" `
                -vnetName "vnet-sc500-lab" `
                -subnetName "snet-frontend" `
                -location $Location `
                -wafMode "Detection" `
                -Mode Incremental `
                -Name "deploy-waf-$(Get-Date -Format 'yyyyMMddHHmm')"

            if ($wafDeployment.ProvisioningState -eq "Succeeded") {
                Write-Success "App Gateway WAF deployment succeeded"
                $publicIp = $wafDeployment.Outputs.appGatewayPublicIP.Value
                Write-Host "    Public IP: $publicIp" -ForegroundColor Green
                Write-Host "    WAF URL:   http://$publicIp"
                Write-Host "    Note: WAF is in Detection mode. Switch to Prevention after testing."
            } else {
                throw "WAF deployment failed: $($wafDeployment.ProvisioningState)"
            }
        }
    } catch {
        Write-Host "    Error deploying WAF: $_" -ForegroundColor Red
        throw
    }
}

#endregion

#region Validation

Write-Step "Validating deployment..."

try {
    $vnet = Get-AzVirtualNetwork -Name "vnet-sc500-lab" -ResourceGroupName $ResourceGroupName
    Write-Success "VNet exists: $($vnet.Name) ($($vnet.Location))"

    $subnets = $vnet.Subnets | Select-Object Name, @{N="Prefix";E={$_.AddressPrefix}}
    Write-Host "`n    Subnets deployed:" -ForegroundColor Cyan
    $subnets | ForEach-Object { Write-Host "      - $($_.Name): $($_.Prefix)" }

    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName
    Write-Host "`n    NSGs deployed:" -ForegroundColor Cyan
    $nsgs | ForEach-Object { Write-Host "      - $($_.Name)" }

    if ($DeployWAF) {
        $agw = Get-AzApplicationGateway -Name "agw-sc500-waf" -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
        if ($agw) {
            Write-Success "App Gateway: $($agw.Name) - State: $($agw.OperationalState)"
        }
    }
} catch {
    Write-Host "    Validation warning: $_" -ForegroundColor Yellow
}

#endregion

Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "Network Lab Deployment Complete!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan
Write-Host "`nNext Steps:"
Write-Host "  1. Review lab-01-network-security.md for portal walk-through"
Write-Host "  2. Review lab-02-waf-setup.md to configure and test WAF"
Write-Host "  3. Run .\cleanup-resources.ps1 when done"
if (-not $DeployWAF) {
    Write-Host "`nTo also deploy the WAF, re-run with: -DeployWAF"
}
Write-Host ""
