# Module 5: Governance & Compliance

## Learning Objectives

By completing this module, you will be able to:

- Create and assign Azure Policy definitions and initiatives
- Understand all policy effects (Deny, Audit, AuditIfNotExists, DeployIfNotExists, Modify, Append, Disabled)
- Use Management Groups to apply policies at scale
- Review Azure RBAC assignments and custom roles through a least-privilege lens
- Apply resource locks correctly and understand their limits
- Review Azure Backup security features such as immutability, soft delete, and multi-user authorization
- Review the Regulatory Compliance dashboard in Defender for Cloud
- Understand common compliance frameworks: ISO 27001, SOC 2, CIS, NIST, PCI-DSS, HIPAA

---

## Module Overview

Governance ensures your Azure environment stays compliant with organizational policies and regulatory requirements over time. Azure Policy and Management Groups are the primary tools.

### Mapped SC-500 Skill Areas

This module primarily maps to **Manage identity, access, and governance (20-25%)** for policy, RBAC, locks, backup security, and governance-as-code. It also supports **Manage and monitor security posture (20-25%)** through compliance assessment workflows in Defender for Cloud. Expect questions on:
- Policy effect differences (Deny vs Audit vs DeployIfNotExists)
- Initiative definitions (a group of policies)
- Regulatory compliance standards and how to assign them
- Management Group hierarchy and policy inheritance
- Resource locks and control-plane vs data-plane distinctions
- Custom roles, least privilege, and overprivileged RBAC remediation
- Azure Backup vault security features such as immutability and MUA
- Remediation tasks and how they work

---

## Labs in This Module

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-azure-policy.md` | Assign built-in + custom deny policy, test, remediate | 45–60 min |
| `lab-03-rbac-locks-backup-iac.md` | Review RBAC, apply locks, inspect backup security, and map governance to IaC | 60–90 min |
| `lab-02-compliance-assessment.md` | Enable compliance standard, review controls, export report | 30–45 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/azure-policy-definitions.json` | ARM template — custom policy definition for required tags |

---

## Key Microsoft Learn Links

- [Govern Azure resources with Azure Policy](https://learn.microsoft.com/en-us/training/modules/intro-to-governance/)
- [Organize your resources with management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard)
- [Implement and manage enforcement of cloud governance policies](https://learn.microsoft.com/en-us/training/modules/implement-manage-enforcement-cloud-governance-policies/)
- [Lock your Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Azure Backup security overview](https://learn.microsoft.com/en-us/azure/backup/security-overview)

---

## Start Here

1. Read `study-guide.md` — understand policy effects and compliance frameworks
2. Complete `lab-01-azure-policy.md` — create and test Azure Policy
3. Complete `lab-03-rbac-locks-backup-iac.md` — add the RBAC, lock, backup, and IaC governance layer
4. Complete `lab-02-compliance-assessment.md` — review the Regulatory Compliance dashboard
5. Deploy `templates/azure-policy-definitions.json` for IaC practice
