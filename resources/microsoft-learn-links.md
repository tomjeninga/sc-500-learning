# Microsoft Learn Links for SC-500

Curated Microsoft Learn paths and modules organized by SC-500 exam domain.

---

## Official Microsoft Learn Starting Points

These are the Microsoft-published learning paths and modules that best map to the SC-500 exam. Microsoft occasionally changes path slugs, so use the study guide if a link moves again.

| Learning Path | Domain Alignment | Duration |
|---------------|-----------------|---------|
| [Protect identity and access in Azure](https://learn.microsoft.com/en-us/training/paths/secure-identity-access/) | Domain 1 | ~6 hrs |
| [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/) | Domain 2 | ~5 hrs |
| [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/) | Domain 3 | ~8 hrs |
| [Secure your cloud data in Azure](https://learn.microsoft.com/en-us/training/paths/secure-your-cloud-data/) | Domain 4 | ~5 hrs |
| [Implement and manage enforcement of cloud governance policies](https://learn.microsoft.com/en-us/training/modules/implement-manage-enforcement-cloud-governance-policies/) | Domain 5 | ~45 min |

**Approximate Microsoft Learn Time for the items above:** ~25 hours

---

## Domain 1: Identity & Governance

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Configure Azure Active Directory](https://learn.microsoft.com/en-us/training/modules/configure-azure-active-directory/) | Tenants, users, groups, licenses | 45 min |
| [Manage identities in Microsoft Entra ID](https://learn.microsoft.com/en-us/training/modules/manage-identities-microsoft-entra-id/) | User lifecycle, guest users, B2B | 45 min |
| [Configure role-based access control](https://learn.microsoft.com/en-us/training/modules/configure-role-based-access-control/) | RBAC scopes, built-in roles, custom roles | 45 min |
| [How to manage groups - Microsoft Entra](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-groups) | Security groups, M365 groups, dynamic groups | 30 min |
| [Plan, implement, and administer Conditional Access](https://learn.microsoft.com/en-us/training/modules/plan-implement-administer-conditional-access/) | Policy conditions, controls, report-only | 45 min |
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
| [Azure DDoS Protection overview](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) | DDoS IP Protection vs Network Protection, telemetry | 30 min |
| [Design and implement private access to Azure Services](https://learn.microsoft.com/en-us/training/modules/design-implement-private-access-to-azure-services/) | Private Link, Private Endpoints, DNS | 45 min |
| [Host security in Azure](https://learn.microsoft.com/en-us/training/modules/host-security/) | JIT, Bastion, disk encryption | 45 min |

### Supplementary Resources

- [NSG documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure Firewall documentation](https://learn.microsoft.com/en-us/azure/firewall/overview)
- [WAF on App Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)
- [Azure Bastion documentation](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Azure Private Link documentation](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview)

### App Platform and Container Breadth Resources

- [Security concepts for AKS applications and clusters](https://learn.microsoft.com/en-us/azure/aks/concepts-security)
- [Enable Defender for Containers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-enable-plan)
- [Azure Container Registry introduction](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro)
- [Authentication and authorization in Azure App Service and Azure Functions](https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)
- [Security overview for Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/security)
- [Validate JWT policy in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/validate-jwt-policy)
- [Limit call rate by key policy in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/rate-limit-by-key-policy)

---

## Domain 3: Security Operations

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Mitigate threats with Defender for Cloud](https://learn.microsoft.com/en-us/training/modules/azure-security-center/) | Plans, Secure Score, recommendations | 45 min |
| [Explain Defender for Cloud features and capabilities](https://learn.microsoft.com/en-us/training/modules/what-is-azure-defender/) | CSPM, CWPP, workload protection | 30 min |
| [Introduction to Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-sentinel/) | Workspace, connectors, analytics | 30 min |
| [Create and manage analytics rules in Sentinel](https://learn.microsoft.com/en-us/training/modules/use-entity-behavior-analytics-azure-sentinel/) | Scheduled, NRT, Fusion, ML rules | 45 min |
| [Kusto Query Language overview for Microsoft Sentinel](https://learn.microsoft.com/en-us/kusto/query/kusto-sentinel-overview?toc=%2Fazure%2Fsentinel%2FTOC.json&bc=%2Fazure%2Fsentinel%2Fbreadcrumb%2Ftoc.json) | KQL basics, operators, aggregation | 60 min |
| [Automate threat response in Sentinel](https://learn.microsoft.com/en-us/training/modules/automation-microsoft-sentinel/) | Playbooks, Logic Apps, automation rules | 45 min |
| [Configure SIEM security operations using Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/configure-siem-security-operations-using-microsoft-sentinel/) | Workbooks, hunt, UEBA | 60 min |

### KQL Practice Resources

- [KQL Quick Reference](https://learn.microsoft.com/en-us/azure/data-explorer/kql-quick-reference)
- [KQL Tutorial for Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/kusto-overview)
- [Azure Data Explorer free cluster](https://dataexplorer.azure.com/clusters/help/databases/Samples) (free KQL playground)

### Sentinel Breadth Resources

- [Deploy and manage Microsoft Sentinel out-of-the-box content](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-solutions-deploy)
- [Ingest Windows Security Events in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/connect-windows-security-events)
- [Ingest Syslog and CEF messages with AMA](https://learn.microsoft.com/en-us/azure/sentinel/connect-cef-syslog-ama)
- [Authenticate playbooks to Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/automation/authenticate-playbooks-to-sentinel)

### Security Copilot Resources

- [Get started with Microsoft Security Copilot](https://learn.microsoft.com/en-us/copilot/security/get-started-security-copilot)
- [Understand authentication in Microsoft Security Copilot](https://learn.microsoft.com/en-us/copilot/security/authentication)
- [Setup and manage Security Copilot agents](https://learn.microsoft.com/en-us/copilot/security/agents-manage)
- [Microsoft Security Copilot agents overview](https://learn.microsoft.com/en-us/copilot/security/agents-overview)
- [Microsoft Security Store in Microsoft Security Copilot](https://learn.microsoft.com/en-us/copilot/security/security-store-integration)

### Defender for Cloud Hybrid and Multicloud Resources

- [Connect non-Azure machines to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-machines)
- [Select a Defender for Servers plan and deployment scope](https://learn.microsoft.com/en-us/azure/defender-for-cloud/plan-defender-for-servers-select-plan)
- [Connect AWS accounts to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-aws)
- [Connect GCP projects to Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-gcp)
- [Secure your hybrid and multicloud machines by using Azure Arc-enabled servers](https://learn.microsoft.com/en-us/training/modules/secure-azure-arc-enabled-servers/)

---

## Domain 4: Data Protection

### Core Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Configure and manage Azure Key Vault](https://learn.microsoft.com/en-us/training/modules/configure-and-manage-azure-key-vault/) | Keys, secrets, certs, access control | 45 min |
| [Secure your Azure Storage account](https://learn.microsoft.com/en-us/training/modules/secure-azure-storage-account/) | SAS, network rules, encryption | 45 min |
| [Secure your Azure SQL Database](https://learn.microsoft.com/en-us/training/modules/secure-your-azure-sql-database/) | TDE, auth, firewall, auditing | 45 min |
| [Implement a secure environment for a database service](https://learn.microsoft.com/en-us/training/paths/implement-secure-environment-database-service/) | SQL TDE, Always Encrypted, masking | 45 min |
| [Benefits and features of Defender for Azure SQL Databases](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-sql-introduction) | Vulnerability assessment, ATP | 30 min |
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
| [Organize your resources with management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | MG hierarchy, policy inheritance | 20 min |
| [Configure Azure Policy](https://learn.microsoft.com/en-us/training/modules/configure-azure-policy/) | Definitions, initiatives, assignments, effects | 45 min |
| [Implement and Manage Enforcement of Cloud Governance Policies](https://learn.microsoft.com/en-us/training/modules/implement-manage-enforcement-cloud-governance-policies/) | Policy enforcement, governance controls, regulatory compliance | 45 min |

### Governance Breadth Resources

- [Lock your Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [List Azure role assignments using the Azure portal](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-list-portal)
- [Azure Backup security overview](https://learn.microsoft.com/en-us/azure/backup/security-overview)

---

## Domain 6: AI Workload Security

### Core Docs and Modules

| Module | Topics Covered | Duration |
|--------|---------------|---------|
| [Microsoft Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/) | Foundry projects, model deployments, AI app security context | Varies |
| [AI Gateway in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities) | Token limits, caching, content safety, observability | 30-45 min |
| [Microsoft Purview DSPM for AI](https://learn.microsoft.com/en-us/purview/ai-microsoft-purview) | Oversharing, Copilot risk discovery, AI posture | 30-45 min |
| [Microsoft Entra Agent ID overview](https://learn.microsoft.com/en-us/entra/identity/agentid/overview) | Agent identities, Conditional Access, governance | 20-30 min |
| [Defender for Cloud AI security](https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-security) | AI threat protection, onboarding, alerts | 30 min |

### AI Governance and Guardrail Resources

- [Security and governance in Microsoft Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance)
- [Foundry content filtering and guardrails](https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/content-filtering)
- [Data and AI security dashboard overview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/data-aware-security-dashboard-overview)

---

## Additional SC-500 Study Resources

### Official Microsoft Resources

- **SC-500 Exam Study Guide:** [https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500)
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
