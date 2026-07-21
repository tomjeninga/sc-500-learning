# SC-500: Cloud and AI Security Engineer Associate

Personal learning repository for **Tom Jeninga** to prepare for **Microsoft Certified: Cloud and AI Security Engineer Associate** and **Exam SC-500: Implementing End-to-End Security Controls for Cloud and AI Workloads**.

This repository is a hands-on study companion: read the concept, build the control, validate the result, clean up, and explain the decision like an exam case study.

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
1. **Build** the control in a lab subscription or developer tenant.
1. **Validate** using Defender for Cloud, Sentinel/KQL, Purview, portal evidence, or logs.
1. **Explain** why the chosen control is better than the distractors.
1. **Clean up** resources and record weak areas.

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

#### Secure access to resources by using Microsoft Entra ID

- [ ] Implement and configure Privileged Identity Management (PIM)
- [ ] Implement conditional access policies
- [ ] Implement and configure authentication methods, including MFA and passwordless
- [ ] Implement and configure identity for applications (enterprise apps and app registrations)
- [ ] Manage OAuth permission grants and consent settings
- [ ] Implement and configure managed identities for Azure resources

#### Secure secrets and keys by using Azure Key Vault

- [ ] Deploy Key Vault
- [ ] Configure Key Vault settings
- [ ] Configure access to Key Vault
- [ ] Configure firewall settings on Key Vault
- [ ] Manage keys, secrets, and certificates
- [ ] Scan for secrets by using Defender CSPM
- [ ] Implement Defender for Key Vault

#### Implement governance to enforce security and regulatory compliance

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

#### Storage accounts

- [ ] Implement and configure security for storage accounts
- [ ] Configure Azure Storage firewall rules
- [ ] Implement Defender for Storage threat protection
- [ ] Manage access to storage, including access policies

#### Databases

- [ ] Implement platform-level security in Azure SQL
- [ ] Configure database auditing (Azure SQL DB and SQL Managed Instance)
- [ ] Configure Defender for Databases across Azure database services

#### Azure network services

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

#### Implement security for AI

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

#### Servers and VMs

- [ ] Implement and configure disk encryption
- [ ] Plan and implement Azure Bastion
- [ ] Enable and enforce just-in-time (JIT) VM access
- [ ] Extend security to hybrid/multicloud servers with Azure Arc
- [ ] Onboard servers to Defender for Servers (hybrid and multicloud)
- [ ] Configure Defender for Servers (vulnerability scanning, EDR)
- [ ] Implement and manage agentless VM scanning
- [ ] Configure VM security features (secure boot, vTPM, integrity monitoring, security type)
- [ ] Enforce server configuration with Azure Machine Configuration

#### Application platform services

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

#### Defender for Cloud

- [ ] Identify security risks with Defender CSPM
- [ ] Evaluate compliance against security frameworks
- [ ] Enable and configure Defender for Cloud workload protection plans
- [ ] Connect hybrid and multicloud (AWS, GCP)
- [ ] Configure Microsoft Defender Vulnerability Management for Azure VMs
- [ ] Discover unprotected assets with Microsoft Defender EASM

#### Microsoft Sentinel

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

#### Microsoft Security Copilot

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
| `resources/kql-workbook.md` | Reusable KQL queries grouped by SC-500 skill area |
| `resources/exam-tips.md` | Exam metadata, AI keyword-to-answer table, common traps |
| `notes/` | Personal wrong-answer journal (git-ignored except README) |
| `.github/agents/sc-500-coach.agent.md` | **SC-500 Coach** teaching agent (pick from Copilot Chat agent picker) |
| `.github/instructions/` | Repo-wide conventions auto-applied by Copilot |
| `.github/skills/sc-500-study-session/` | Slash-callable study session workflow |
| `.github/workflows/` | CI: markdown lint + Bicep/ARM validate |

## Start here

1. Read `ROADMAP.md`.
1. Complete `AZURE-SETUP.md`.
1. Review `resources\microsoft-learn-links.md`.
1. Start Week 1 and track wrong answers in your own study notes.
1. Use the workspace **SC-500 Coach** agent for study debriefs and lab review.

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
