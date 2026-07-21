# Domain 5: Governance & Compliance

## Learning Objectives

By completing this domain, you will be able to:

- Create and assign Azure Policy definitions and initiatives
- Understand all policy effects (Deny, Audit, AuditIfNotExists, DeployIfNotExists, Modify, Append, Disabled)
- Use Management Groups to apply policies at scale
- Review the Regulatory Compliance dashboard in Defender for Cloud
- Understand common compliance frameworks: ISO 27001, SOC 2, CIS, NIST, PCI-DSS, HIPAA

---

## Domain Overview

Governance ensures your Azure environment stays compliant with organizational policies and regulatory requirements over time. Azure Policy and Management Groups are the primary tools.

### SC-500 Exam Weight: ~15–20%

Expect questions on:

- Policy effect differences (Deny vs Audit vs DeployIfNotExists)
- Initiative definitions (a group of policies)
- Regulatory compliance standards and how to assign them
- Management Group hierarchy and policy inheritance
- Remediation tasks and how they work

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-azure-policy.md` | Assign built-in + custom deny policy, test, remediate | 45–60 min |
| `lab-02-compliance-assessment.md` | Enable compliance standard, review controls, export report | 30–45 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/azure-policy-definitions.json` | ARM template — custom policy definition for required tags |

---

## Key Microsoft Learn Links

- [Govern Azure resources with Azure Policy](https://learn.microsoft.com/en-us/training/modules/intro-to-governance/)
- [Introduction to Management Groups](https://learn.microsoft.com/en-us/training/modules/describe-azure-management-groups/)
- [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard)
- [SC-500: Manage governance and compliance](https://learn.microsoft.com/en-us/training/paths/governance-compliance-azure-security/)

---

## Start Here

1. Read `study-guide.md` — understand policy effects and compliance frameworks
1. Complete `lab-01-azure-policy.md` — create and test Azure Policy
1. Complete `lab-02-compliance-assessment.md` — review the Regulatory Compliance dashboard
1. Deploy `templates/azure-policy-definitions.json` for IaC practice
