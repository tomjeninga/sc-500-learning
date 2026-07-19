# Lab 02: Regulatory Compliance Assessment

## Overview

**Estimated Time:** 30–45 minutes  
**Estimated Cost:** $0 (Regulatory compliance dashboard is part of Foundational CSPM — free)  
**Difficulty:** Beginner–Intermediate

---

## What You'll Build and WHY

You will enable a regulatory compliance standard (CIS Microsoft Azure Foundations Benchmark) in Defender for Cloud, review control compliance, identify failing controls, and export a compliance report.

**Why this matters:**
- Regulatory compliance management is directly tested on SC-500
- You need to know how to assign a compliance standard, read the dashboard, and export reports
- Understanding which framework applies to which industry is tested conceptually

---

## Prerequisites

- Defender for Cloud enabled (Foundational CSPM — free)
- Security Reader or Security Admin role

---

## Part 1: Enable a Compliance Standard

### Step 1.1 — Open Regulatory Compliance

1. In Azure Portal, search for **Microsoft Defender for Cloud**
2. In the left menu, click **Regulatory compliance**
3. Review the default standards already shown (usually Microsoft Cloud Security Benchmark is pre-enabled)

### Step 1.2 — Add CIS Microsoft Azure Foundations Benchmark

4. Click **Manage compliance policies** (top of the page)
5. Select your subscription from the list
6. Scroll down to **Industry and regulatory standards**
7. Click **Add more standards**
8. Search for `CIS Microsoft Azure Foundations Benchmark v2.0.0`
9. Click **Add**
10. Wait 5–15 minutes for the compliance data to populate

### Step 1.3 — Add NIST SP 800-53 (optional)

Repeat the process to add:
- `NIST SP 800-53 Rev. 5`

This gives you a second framework to compare.

---

## Part 2: Review Compliance Dashboard

### Step 2.1 — Review overall compliance

1. Return to **Regulatory compliance**
2. Select the **CIS Microsoft Azure Foundations Benchmark** tab
3. Review:
   - **Overall compliance percentage**
   - **Control domain list** (e.g., "1. Identity and Access Management", "2. Security Center")

### Step 2.2 — Drill into a failing control

4. Click on a control with failing resources (shown in red/orange)
5. For example: **"1.1 Ensure that Multi-Factor Authentication is enabled for all users with owner permissions"**
6. Review:
   - **Failing resources** — which accounts don't have MFA
   - **Passing resources** — which accounts comply
   - **Related recommendations** — links to Defender for Cloud recommendations

### Step 2.3 — Remediate from compliance view

7. Click on a failing recommendation within a control
8. View the **Remediation steps** (same as in Secure Score)
9. For MFA-related controls, click **View recommendation**
10. Follow remediation steps (typically: enable MFA for affected users in Entra ID)

---

## Part 3: Review Microsoft Cloud Security Benchmark

### Step 3.1 — Review MCSB controls

The **Microsoft Cloud Security Benchmark (MCSB)** is enabled by default and covers Microsoft's own security best practices for Azure.

1. Click on **Microsoft Cloud Security Benchmark** tab
2. Review control categories:
   - NS (Network Security)
   - IM (Identity Management)
   - PA (Privileged Access)
   - DP (Data Protection)
   - AM (Asset Management)
   - LT (Logging and Threat Detection)
   - IR (Incident Response)
   - VA (Vulnerability Assessment)

3. Click on any failing control to see affected resources and remediation steps

---

## Part 4: Export a Compliance Report

### Step 4.1 — Download a PDF compliance report

1. In Regulatory compliance, select the **CIS Benchmark** tab
2. Click **Download report** (top of page)
3. Select:
   - **Report format:** PDF
   - **Standard:** CIS Microsoft Azure Foundations Benchmark
4. Click **Download**
5. ✅ A PDF report is generated showing compliance status for all controls

> **Use case:** This report is often required for audit evidence — auditors want to see your compliance posture against a standard.

### Step 4.2 — Configure continuous export (optional)

For ongoing compliance monitoring:
1. In Defender for Cloud → **Environment settings** → Your subscription
2. Click **Continuous export**
3. Enable **Regulatory compliance data** → Export to Log Analytics workspace
4. This enables KQL queries on compliance data over time

---

## Validation Steps

```powershell
# List regulatory compliance standards assigned to your subscription
Get-AzSecurityRegulatoryComplianceStandard | Select-Object Name, State, PassedControls, FailedControls | Format-Table

# Get failing controls for CIS Benchmark
Get-AzSecurityRegulatoryComplianceControl -StandardName "CIS Microsoft Azure Foundations Benchmark" |
    Where-Object { $_.State -eq "Failed" } |
    Select-Object Id, Name, State, FailedAssessments |
    Format-Table
```

---

## Understanding Compliance Scores

**Important:** Regulatory compliance scores in Defender for Cloud reflect policy evaluation only — they do NOT provide legal or contractual compliance certification.

| Score | Meaning |
|-------|---------|
| 100% | All evaluated resources pass all controls |
| 80–99% | Most controls pass; some gaps to address |
| Below 80% | Significant gaps; prioritize remediation |

**For actual compliance certification** (e.g., ISO 27001 certificate), you need:
- Third-party audit
- Evidence collection and documentation
- Formal audit process

Defender for Cloud helps you **prepare** for audits by showing your technical control coverage.

---

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Standard shows 0% / no data | Still initializing | Wait 15–30 minutes after enabling |
| "Add more standards" not visible | Insufficient permissions | Need Security Admin or Owner |
| Controls show N/A | Resources not in scope | Some controls apply to specific service types |
| Export report button grayed out | No compliance data yet | Wait for initial assessment to complete |

---

## Common Compliance Framework Quick Reference

| Framework | Who Uses It | Azure Standard Name |
|-----------|------------|-------------------|
| **ISO 27001** | Any industry, international | ISO 27001:2013 |
| **SOC 2** | US cloud service providers | SOC TSP |
| **CIS Benchmarks** | IT security teams | CIS Microsoft Azure Foundations Benchmark |
| **NIST SP 800-53** | US federal, contractors | NIST SP 800-53 Rev. 5 |
| **PCI-DSS** | Payment card organizations | PCI DSS v4 |
| **HIPAA** | US healthcare organizations | HIPAA |
| **FedRAMP** | US federal cloud services | FedRAMP High |

---

## Cleanup Instructions

To remove a compliance standard:

1. Defender for Cloud → Environment settings → Your subscription
2. Find the compliance standard in the policy assignment list
3. Delete the policy initiative assignment

```powershell
# List compliance-related policy assignments
Get-AzPolicyAssignment | Where-Object { $_.Properties.DisplayName -like "*CIS*" -or $_.Properties.DisplayName -like "*NIST*" } |
    Select-Object Name, @{N="DisplayName";E={$_.Properties.DisplayName}} | Format-Table

# Remove a specific assignment
Remove-AzPolicyAssignment -Name "<assignment-name>"
```

---

## Key Takeaways

- Regulatory compliance in Defender for Cloud uses Azure Policy under the hood
- The dashboard shows real-time pass/fail status for each control
- You can export PDF reports for audit evidence
- Multiple frameworks can be active simultaneously
- 100% compliance score ≠ certified compliance — you still need formal audits
- MCSB (Microsoft Cloud Security Benchmark) is always enabled and provides baseline guidance
