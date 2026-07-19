# Microsoft Learn Links for SC-500

Curated Microsoft Learn paths and modules organized by SC-500 exam domain.

---

## Official SC-500 Learning Paths

These are the Microsoft-published learning paths that map directly to the SC-500 exam:

| Learning Path | Domain Alignment | Duration |
|---------------|-----------------|---------|
| [SC-500: Implement identity and access management](https://learn.microsoft.com/en-us/training/paths/implement-identity-access-management/) | Domain 1 | ~6 hrs |
| [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/) | Domain 2 | ~5 hrs |
| [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/) | Domain 3 | ~8 hrs |
| [SC-500: Secure data and applications](https://learn.microsoft.com/en-us/training/paths/secure-data-applications/) | Domain 4 | ~5 hrs |
| [SC-500: Manage governance and compliance](https://learn.microsoft.com/en-us/training/paths/governance-compliance-azure-security/) | Domain 5 | ~3 hrs |

**Total Microsoft Learn Study Time:** ~27 hours

---

## Domain 1: Identity & Governance

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Configure Azure Active Directory](https://learn.microsoft.com/en-us/training/modules/configure-azure-active-directory/) | Tenants, users, groups, licenses | 45 min |
| [Manage identities in Microsoft Entra ID](https://learn.microsoft.com/en-us/training/modules/manage-identities-microsoft-entra-id/) | User lifecycle, guest users, B2B | 45 min |
| [Configure role-based access control](https://learn.microsoft.com/en-us/training/modules/configure-role-based-access-control/) | RBAC scopes, built-in roles, custom roles | 45 min |
| [Manage Microsoft Entra groups](https://learn.microsoft.com/en-us/training/modules/manage-microsoft-entra-groups/) | Security groups, M365 groups, dynamic groups | 30 min |
| [Configure Azure AD Conditional Access](https://learn.microsoft.com/en-us/training/modules/azure-ad-privileged-identity-management/) | Policy conditions, controls, report-only | 45 min |
| [Plan and implement Privileged Identity Management](https://learn.microsoft.com/en-us/training/modules/plan-implement-privileged-access/) | PIM, JIT access, access reviews | 60 min |
| [Protect identities with Entra ID Protection](https://learn.microsoft.com/en-us/training/modules/protect-identities-with-aad-idp/) | Risk policies, risky users, risky sign-ins | 45 min |

### Supplementary Resources

- [Zero Trust Guidance Center](https://learn.microsoft.com/en-us/security/zero-trust/)
- [Microsoft Entra ID documentation](https://learn.microsoft.com/en-us/entra/identity/)
- [Azure RBAC documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/)
- [Conditional Access policies deep dive](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)

---

## Domain 2: Platform Protection

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/) | NSG rules, flow logs, effective rules | 45 min |
| [Secure network connectivity on Azure](https://learn.microsoft.com/en-us/training/modules/secure-network-connectivity-azure/) | NSG, Firewall, DDoS, Bastion, VPN | 45 min |
| [Introduction to Azure Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/) | DNAT, network rules, app rules, threat intel | 30 min |
| [Introduction to Azure Web Application Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-web-application-firewall/) | WAF modes, OWASP, custom rules | 30 min |
| [Configure Azure DDoS Protection](https://learn.microsoft.com/en-us/training/modules/configure-azure-ddos-protection/) | DDoS Basic vs Standard, telemetry | 30 min |
| [Implement Private Endpoints](https://learn.microsoft.com/en-us/training/modules/implement-azure-container-apps/) | Private Link, Private Endpoints, DNS | 45 min |
| [Host security in Azure](https://learn.microsoft.com/en-us/training/modules/host-security/) | JIT, Bastion, disk encryption | 45 min |

### Supplementary Resources

- [NSG documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure Firewall documentation](https://learn.microsoft.com/en-us/azure/firewall/overview)
- [WAF on App Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)
- [Azure Bastion documentation](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Azure Private Link documentation](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview)

---

## Domain 3: Security Operations

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Mitigate threats with Defender for Cloud](https://learn.microsoft.com/en-us/training/modules/azure-security-center/) | Plans, Secure Score, recommendations | 45 min |
| [Explain Defender for Cloud features and capabilities](https://learn.microsoft.com/en-us/training/modules/what-is-azure-defender/) | CSPM, CWPP, workload protection | 30 min |
| [Introduction to Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-sentinel/) | Workspace, connectors, analytics | 30 min |
| [Create and manage analytics rules in Sentinel](https://learn.microsoft.com/en-us/training/modules/use-entity-behavior-analytics-azure-sentinel/) | Scheduled, NRT, Fusion, ML rules | 45 min |
| [Construct KQL statements for Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/construct-kql-statements-microsoft-sentinel/) | KQL basics, operators, aggregation | 60 min |
| [Automate threat response in Sentinel](https://learn.microsoft.com/en-us/training/modules/automation-microsoft-sentinel/) | Playbooks, Logic Apps, automation rules | 45 min |
| [Configure SIEM security operations using Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/configure-siem-security-operations-using-microsoft-sentinel/) | Workbooks, hunt, UEBA | 60 min |

### KQL Practice Resources

- [KQL Quick Reference](https://learn.microsoft.com/en-us/azure/data-explorer/kql-quick-reference)
- [KQL Tutorial for Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/kusto-overview)
- [Azure Data Explorer free cluster](https://dataexplorer.azure.com/clusters/help/databases/Samples) (free KQL playground)

---

## Domain 4: Data Protection

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Configure and manage Azure Key Vault](https://learn.microsoft.com/en-us/training/modules/configure-and-manage-azure-key-vault/) | Keys, secrets, certs, access control | 45 min |
| [Secure your Azure Storage account](https://learn.microsoft.com/en-us/training/modules/secure-azure-storage-account/) | SAS, network rules, encryption | 45 min |
| [Secure your Azure SQL Database](https://learn.microsoft.com/en-us/training/modules/secure-your-azure-sql-database/) | TDE, auth, firewall, auditing | 45 min |
| [Implement database security](https://learn.microsoft.com/en-us/training/modules/implement-database-security/) | SQL TDE, Always Encrypted, masking | 45 min |
| [Configure Azure Defender for SQL](https://learn.microsoft.com/en-us/training/modules/configure-azure-sql-advanced-data-security/) | Vulnerability assessment, ATP | 30 min |
| [Protect information with Microsoft Purview](https://learn.microsoft.com/en-us/training/modules/m365-compliance-information-protect-information/) | Sensitivity labels, DLP | 60 min |

### Supplementary Resources

- [Azure Storage security best practices](https://learn.microsoft.com/en-us/azure/storage/blobs/security-recommendations)
- [Key Vault best practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices)
- [Always Encrypted documentation](https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-azure-key-vault-configure)
- [Microsoft Purview documentation](https://learn.microsoft.com/en-us/purview/)

---

## Domain 5: Governance & Compliance

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Introduction to Azure governance](https://learn.microsoft.com/en-us/training/modules/intro-to-governance/) | Locks, policy, management groups | 30 min |
| [Build a cloud governance strategy on Azure](https://learn.microsoft.com/en-us/training/modules/build-cloud-governance-strategy-azure/) | Policy, RBAC, Cost Management | 45 min |
| [Describe Azure management groups](https://learn.microsoft.com/en-us/training/modules/describe-azure-management-groups/) | MG hierarchy, policy inheritance | 20 min |
| [Configure Azure Policy](https://learn.microsoft.com/en-us/training/modules/configure-azure-policy/) | Definitions, initiatives, assignments, effects | 45 min |
| [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/training/modules/governance-security/) | Dashboard, standards, export | 30 min |

---

## Additional SC-500 Study Resources

### Official Microsoft Resources

- **SC-500 Exam Study Guide:** [https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500)
- **SC-500 Exam Page:** [https://learn.microsoft.com/en-us/credentials/certifications/exams/sc-500](https://learn.microsoft.com/en-us/credentials/certifications/exams/sc-500)
- **Microsoft Security Documentation Hub:** [https://learn.microsoft.com/en-us/azure/security/](https://learn.microsoft.com/en-us/azure/security/)
- **Microsoft Cloud Security Blog:** [https://www.microsoft.com/en-us/security/blog/](https://www.microsoft.com/en-us/security/blog/)

### Microsoft Learn Collections

- [Microsoft Security collection](https://learn.microsoft.com/en-us/collections/yjk01bx4rj0k?WT.mc_id=cloudskillschallenge_)
- [Security Operations Analyst (SC-200) - also useful for Sentinel knowledge](https://learn.microsoft.com/en-us/credentials/certifications/exams/sc-200)

---

## Suggested Daily Study Schedule

| Day | Time | Activity |
|-----|------|----------|
| Mon | 1.5 hrs | Microsoft Learn module |
| Tue | 1.5 hrs | Study guide reading |
| Wed | 2.5 hrs | Hands-on lab |
| Thu | 1.5 hrs | Microsoft Learn module |
| Fri | 2.5 hrs | Hands-on lab + review |
| Sat | 1.5 hrs | Practice questions |
| Sun | Rest | — |

**Total: ~11.5 hrs/week**

---

*Last updated: July 2026 | Aligned to SC-500 exam version published April 2024+*
