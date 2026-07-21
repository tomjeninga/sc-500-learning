# Domain 1: Identity & Governance

## Learning Objectives

By completing this domain, you will be able to:

- Configure and manage Microsoft Entra ID (formerly Azure Active Directory)
- Implement Role-Based Access Control (RBAC) following least-privilege principles
- Design and deploy Conditional Access policies
- Enable and manage Privileged Identity Management (PIM)
- Configure Multi-Factor Authentication (MFA)
- Create and manage Access Reviews

---

## Domain Overview

Identity is the **first line of defence** in Microsoft's Zero Trust model. "Never trust, always verify" — meaning every access request must be authenticated and authorized regardless of where it originates.

### SC-500 Exam Weight: ~25–30%

This is the **heaviest domain** on the exam. Expect questions on:

- Entra ID tenant structure and licensing
- RBAC scope, role definitions, and inheritance
- Conditional Access policy conditions and controls
- PIM activation, approval workflows, and access reviews
- MFA registration and enforcement methods

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-entra-id-setup.md` | Create users/groups, assign RBAC, test least-privilege | 60–90 min |
| `lab-02-conditional-access.md` | Require MFA for admins, block legacy auth, location-based policy | 60–90 min |

---

## Templates & Scripts

| File | Purpose |
| ------ | --------- |
| `templates/rbac-assignments.json` | ARM template for RBAC role assignments |
| `templates/conditional-access-policy.json` | Reference Conditional Access policy (Graph API) |
| `scripts/setup-entra-id-lab.ps1` | Creates resource group, test users, groups |
| `scripts/create-test-users.ps1` | Bulk-creates test users in Entra ID |

---

## Key Microsoft Learn Links

- [Configure Azure Active Directory](https://learn.microsoft.com/en-us/training/modules/configure-azure-active-directory/)
- [Manage identities in Microsoft Entra ID](https://learn.microsoft.com/en-us/training/modules/manage-identities-microsoft-entra-id/)
- [Configure role-based access control](https://learn.microsoft.com/en-us/training/modules/configure-role-based-access-control/)
- [Manage Microsoft Entra identities](https://learn.microsoft.com/en-us/training/paths/implement-identity-access-management/)

---

## Start Here

1. Read `study-guide.md` — understand the concepts
1. Complete `lab-01-entra-id-setup.md` — build it in Azure Portal
1. Complete `lab-02-conditional-access.md` — configure access policies
1. Run the PowerShell scripts to automate the setup
1. Answer the self-check questions at the end of each file
