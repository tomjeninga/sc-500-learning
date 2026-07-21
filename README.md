# SC-500: Cloud and AI Security Engineer Associate

Hands-on study repository for **Microsoft Certified: Cloud and AI Security Engineer Associate** and **Exam SC-500: Implementing End-to-End Security Controls for Cloud and AI Workloads**.

This repository is a practical study companion: read the concept, build the control, validate the result, clean up, and explain the decision like an exam case study.

## Who this repo is for

This repository is designed for:

- Security engineers preparing for **SC-500**
- Cloud engineers who already know basic Azure administration and want stronger security depth
- Microsoft Entra ID, Defender for Cloud, Sentinel, Purview, and AI security learners
- People who prefer a **hands-on path** instead of only reading Microsoft Learn modules

This repository is **not** meant to be:

- A full replacement for Microsoft Learn
- A first Azure tutorial for complete beginners
- A guarantee that every portal screen looks identical over time

## How to use this repo

Recommended flow:

1. Read this `README.md` end to end.
2. Review `ROADMAP.md` for the full study sequence.
3. Complete `AZURE-SETUP.md` and confirm you understand lab cost and licensing needs.
4. Follow the **SC-500 priority path** first.
5. Use `resources/kql-workbook.md` and `resources/exam-tips.md` alongside the labs.
6. Track weak areas in your own notes or local `notes/` folder.

## Cost and licensing warning

Some labs can incur real cost or require paid licensing. Before you begin, review:

- Azure consumption for services such as **API Management**, **Application Gateway WAF**, **Sentinel / Log Analytics**, **SQL**, and **Defender plans**
- Microsoft Entra ID licensing requirements such as **P1** or **P2**
- Microsoft 365 / Purview requirements for **DSPM for AI**, **DLP**, and **sensitivity labels**

Use a dedicated lab resource group, set budgets, and delete resources promptly after each lab.

## Disclaimer

- This is an **unofficial community study repository**
- Always validate pricing, licensing, and portal steps against current Microsoft documentation
- Use this repo together with the official SC-500 study guide and Microsoft Learn
- Exam objectives can change over time, so treat the official study guide as the source of truth

## Why this path is different from AZ-500

The original repository had useful Azure security content, but it was closer to AZ-500. SC-500 is newer and includes cloud plus AI security. The current exam focuses on:

- Identity, access, governance, Key Vault, RBAC, PIM, and policy.
- Storage, database, and network security.
- Compute security across VMs, servers, containers, app platforms, APIs, WAF, and AI.
- Defender for Cloud, Microsoft Sentinel, Security Copilot, hybrid, and multicloud posture.
- AI workload security with Microsoft Foundry, AI Gateway, Defender for AI Service, Purview DSPM, Copilot/agent risks, and Entra Agent ID.

## Official SC-500 skill map

| Skill area | Weight | Repository coverage |
| --- | ---: | --- |
| Manage identity, access, and governance | 20-25% | `01-identity-governance/`, `05-governance-compliance/`, Key Vault content |
| Secure storage, databases, and networking | 25-30% | `02-platform-protection/`, `04-data-protection/` |
| Secure compute | 20-25% | VM/app platform security plus `06-ai-workload-security/` |
| Manage and monitor security posture | 20-25% | `03-security-operations/`, Defender for Cloud, Sentinel |

## Recommended learning loop

Use this pattern for every topic:

1. **Read** the Microsoft Learn skill bullet and repo study guide.
2. **Build** the control in a lab subscription or developer tenant.
3. **Validate** using Defender for Cloud, Sentinel/KQL, Purview, portal evidence, or logs.
4. **Explain** why the chosen control is better than the distractors.
5. **Clean up** resources and record weak areas.

## Repository modules

| Module | Purpose |
| --- | --- |
| `01-identity-governance/` | Entra ID, RBAC, Conditional Access, PIM, MFA |
| `02-platform-protection/` | NSGs, WAF, Bastion, private access, network isolation |
| `03-security-operations/` | Defender for Cloud, Sentinel, KQL, detection and response |
| `04-data-protection/` | Storage, SQL, Key Vault, CMK, private endpoints |
| `05-governance-compliance/` | Azure Policy, compliance, remediation |
| `06-ai-workload-security/` | AI Gateway, Foundry guardrails, Defender for AI Service, Purview DSPM, Entra Agent ID |

## SC-500 skills index (official study guide)

Source: <https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500>

Use this as your master checklist. Each bullet is an exam-measured skill. Tick them off as you complete the matching lab or study guide.

### 1. Manage identity, access, and governance (20-25%) -> `01-identity-governance/`, `05-governance-compliance/`

**Secure access to resources by using Microsoft Entra ID**
- [ ] Implement and configure Privileged Identity Management (PIM)
- [ ] Implement conditional access policies
- [ ] Implement and configure authentication methods, including MFA and passwordless
- [ ] Implement and configure identity for applications (enterprise apps and app registrations)
- [ ] Manage OAuth permission grants and consent settings
- [ ] Implement and configure managed identities for Azure resources

**Secure secrets and keys by using Azure Key Vault**
- [ ] Deploy Key Vault
- [ ] Configure Key Vault settings
- [ ] Configure access to Key Vault
- [ ] Configure firewall settings on Key Vault
- [ ] Manage keys, secrets, and certificates
- [ ] Scan for secrets by using Defender CSPM
- [ ] Implement Defender for Key Vault

**Implement governance to enforce security and regulatory compliance**
- [ ] Implement security controls with Azure Policy (built-in and custom)
- [ ] Evaluate regulatory compliance with Microsoft Defender for Cloud
- [ ] Implement security standards and recommendations in Defender for Cloud
- [ ] Implement resource locks
- [ ] Manage Azure built-in role assignments
- [ ] Manage custom roles (Azure and Entra roles)
- [ ] Evaluate and remediate overprivileged access with Azure RBAC
- [ ] Configure backup protection with Azure Backup security features
- [ ] Implement security controls with Infrastructure as Code

### 2. Secure storage, databases, and networking (25-30%) -> `02-platform-protection/`, `04-data-protection/`

**Storage accounts**
- [ ] Implement and configure security for storage accounts
- [ ] Configure Azure Storage firewall rules
- [ ] Implement Defender for Storage threat protection
- [ ] Manage access to storage, including access policies

**Databases**
- [ ] Implement platform-level security in Azure SQL
- [ ] Configure database auditing (Azure SQL DB and SQL Managed Instance)
- [ ] Configure Defender for Databases across Azure database services

**Azure network services**
- [ ] Implement and manage NSGs and ASGs
- [ ] Configure network access policies with Azure Virtual Network Manager
- [ ] Configure security for an Azure Virtual WAN
- [ ] Configure security for VPN connections
- [ ] Implement and configure Microsoft Entra Private Access
- [ ] Configure Azure private endpoints for PaaS resources
- [ ] Configure Azure Private Link services
- [ ] Implement and configure Azure Firewall
- [ ] Evaluate effective security rules with Network Watcher diagnostics

### 3. Secure compute (20-25%) -> `02-platform-protection/`, `06-ai-workload-security/`

**Implement security for AI**
- [ ] Identify overexposure of data in SharePoint
- [ ] Identify Copilot/AI app risks using Microsoft Purview DSPM
- [ ] Enable real-time protection for Microsoft Copilot Studio agents
- [ ] Implement Conditional Access for Microsoft Entra Agent ID
- [ ] Analyze blast radius for Entra Agent ID using Defender XDR
- [ ] Manage Entra Agent ID access
- [ ] Configure and deploy AI Gateway in Azure API Management for Microsoft Foundry
- [ ] Enable Defender for AI Service in Defender for Cloud
- [ ] Configure guardrails for agent security in Foundry
- [ ] Monitor AI security with the Data and AI security dashboard in Defender for Cloud
- [ ] Manage agents in the Microsoft 365 admin center

**Servers and VMs**
- [ ] Implement and configure disk encryption
- [ ] Plan and implement Azure Bastion
- [ ] Enable and enforce just-in-time (JIT) VM access
- [ ] Extend security to hybrid/multicloud servers with Azure Arc
- [ ] Onboard servers to Defender for Servers (hybrid and multicloud)
- [ ] Configure Defender for Servers (vulnerability scanning, EDR)
- [ ] Implement and manage agentless VM scanning
- [ ] Configure VM security features (secure boot, vTPM, integrity monitoring, security type)
- [ ] Enforce server configuration with Azure Machine Configuration

**Application platform services**
- [ ] Detect container misconfigurations and runtime risks with Defender for Containers
- [ ] Implement security controls for Azure Kubernetes Service (AKS)
- [ ] Implement security controls for Azure Container Registry
- [ ] Implement security controls for Container Instances and Container Apps
- [ ] Implement security controls for Azure Functions (auth and network access)
- [ ] Implement security controls for Azure Logic Apps
- [ ] Implement security controls for Azure App Service
- [ ] Implement and configure Azure Web Application Firewall
- [ ] Implement back-end API protection with API Management policies

### 4. Manage and monitor security posture (20-25%) -> `03-security-operations/`

**Defender for Cloud**
- [ ] Identify security risks with Defender CSPM
- [ ] Evaluate compliance against security frameworks
- [ ] Enable and configure Defender for Cloud workload protection plans
- [ ] Connect hybrid and multicloud (AWS, GCP)
- [ ] Configure Microsoft Defender Vulnerability Management for Azure VMs
- [ ] Discover unprotected assets with Microsoft Defender EASM

**Microsoft Sentinel**
- [ ] Create and connect Sentinel workspaces
- [ ] Assign roles in Microsoft Sentinel
- [ ] Implement and use content hub solutions
- [ ] Configure Microsoft data connectors for Azure resources
- [ ] Configure syslog and CEF event collection
- [ ] Configure Windows Security event collection with data collection rules (incl. WEF)
- [ ] Create custom log tables in the workspace
- [ ] Implement automation rules and playbooks
- [ ] Implement data retention in Sentinel data stores
- [ ] Query Microsoft Purview Audit in Defender XDR

**Microsoft Security Copilot**
- [ ] Configure workspaces for Security Copilot
- [ ] Manage permissions and roles
- [ ] Enable and configure plugins
- [ ] Enable and configure Microsoft agents and Security Store agents

## Repo tour

| Path | What it is |
| --- | --- |
| `01-identity-governance/` … `05-governance-compliance/` | Traditional cloud security modules (labs + ARM templates) |
| `06-ai-workload-security/` | **AI security module** - Foundry, APIM AI Gateway, Purview DSPM, Entra Agent ID, Defender for AI |
| `06-ai-workload-security/architecture.md` | Mermaid stack + sequence + trust-boundary diagrams for AI workloads |
| `infra/` | **Bicep** versions of every ARM template + `main.bicep` orchestrator |
| `resources/lab-matrix.md` | Quick prerequisites, cost, and time matrix for the main labs |
| `resources/kql-workbook.md` | Reusable KQL queries grouped by SC-500 skill area |
| `resources/exam-tips.md` | Exam metadata, AI keyword-to-answer table, common traps |
| `notes/` | Private notes template (git-ignored except README) |
| `.github/agents/sc-500-coach.agent.md` | **SC-500 Coach** teaching agent (pick from Copilot Chat agent picker) |
| `.github/instructions/` | Repo-wide conventions auto-applied by Copilot |
| `.github/skills/sc-500-study-session/` | Slash-callable study session workflow |
| `.github/workflows/` | CI: markdown lint + Bicep/ARM validate |
| `CONTRIBUTING.md` | Contribution guidelines for public improvements |
| `LICENSE` | Repository license |

## SC-500 priority path (do these labs first)

If your goal is the **fastest path to exam readiness**, do these 11 labs before
anything else. They cover the highest-yield SC-500 decisions without drowning
you in too much Azure-only detail.

| Priority | Lab | Why it is high value |
| --- | --- | --- |
| 1 | `01-identity-governance/lab-02-conditional-access.md` | Conditional Access, MFA, report-only, and blocking legacy auth are core exam patterns |
| 2 | `01-identity-governance/lab-03-pim-access-governance.md` | Teaches PIM vs Access Reviews vs Access Packages - a classic SC-500 distinction |
| 3 | `01-identity-governance/lab-04-workload-identities.md` | Secretless access, managed identities, and federated credentials show up often |
| 4 | `04-data-protection/lab-01-storage-encryption.md` | CMK, Key Vault RBAC, and Private Endpoint are foundational |
| 5 | `02-platform-protection/lab-03-private-access-patterns.md` | Helps you nail Private Endpoint vs Service Endpoint vs firewall decisions |
| 6 | `04-data-protection/lab-02-database-security.md` | TDE, Entra auth, auditing, Defender for SQL, and data classification |
| 7 | `03-security-operations/lab-01-defender-cloud.md` | Defender for Cloud plans, recommendations, and Secure Score |
| 8 | `03-security-operations/lab-02-sentinel-setup.md` | Sentinel onboarding, connectors, analytics rules, and KQL basics |
| 9 | `03-security-operations/lab-03-sentinel-triage-investigation.md` | Incident triage and KQL pivots - more SC-500 realistic than setup alone |
| 10 | `04-data-protection/lab-03-purview-labels-dlp-dspm.md` | Purview labels, DLP, and DSPM for AI are major SC-500 differentiators |
| 11 | `06-ai-workload-security/lab-01-ai-gateway.md` | AI Gateway in APIM is one of the most distinctive new SC-500 topics |

**Then finish with these AI labs:**
- `06-ai-workload-security/lab-02-purview-dspm-copilot.md`
- `06-ai-workload-security/lab-03-entra-agent-id.md`
- `06-ai-workload-security/lab-04-defender-for-ai.md`

**Suggested order by week:**
1. **Week 1:** Priorities 1-3
2. **Week 2:** Priorities 4-6
3. **Week 3:** Priorities 7-9
4. **Week 4:** Priorities 10-11 + the remaining three AI labs

## Final 3 additions for near-complete SC-500 coverage

After you finish the priority path, use these three labs to close the biggest
remaining official study-guide gaps:

1. `01-identity-governance/lab-05-enterprise-app-governance.md`
   - Covers enterprise apps, app registrations, OAuth permission grants, admin consent workflow, and assignment controls
2. `02-platform-protection/lab-04-vm-security.md`
   - Covers Defender for Servers, JIT VM access, trusted launch, secure boot, vTPM, and agentless scanning
3. `02-platform-protection/lab-05-app-platform-security.md`
   - Covers App Service, Functions, Container Apps, and API Management back-end protection

These are not the fastest-pass labs, but they bring the repo much closer to the
full official study guide.

## Start here

1. Read `ROADMAP.md`.
2. Complete `AZURE-SETUP.md`.
3. Review `resources\microsoft-learn-links.md`.
4. Start Week 1 and track wrong answers in your own study notes.
5. Use the workspace **SC-500 Coach** agent for study debriefs and lab review.

## Exam readiness checklist

- [ ] I can explain all four SC-500 skill areas without notes.
- [ ] I completed every hands-on lab at least once.
- [ ] I can write basic KQL for Sentinel investigation scenarios.
- [ ] I can compare Key Vault RBAC/access policies, CMK/PMK, TDE/Always Encrypted, NSG/Firewall/WAF, and Private Endpoint/Service Endpoint.
- [ ] I can describe AI workload security with Foundry guardrails, AI Gateway, Purview DSPM, Defender for AI Service, Entra Agent ID, and Security Copilot.
- [ ] Practice scores are consistently above 80%, with no domain below 70%.

## Official references

- SC-500 study guide: <https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500>
- Exam sandbox: <https://aka.ms/examdemo>
- Microsoft Defender for Cloud: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/>
- Microsoft Sentinel: <https://learn.microsoft.com/en-us/azure/sentinel/>
- Microsoft Purview: <https://learn.microsoft.com/en-us/purview/>

Last updated: July 2026
