# Module 3: Security Operations

## Learning Objectives

By completing this module, you will be able to:

- Enable and configure Microsoft Defender for Cloud
- Understand and improve Secure Score
- Enable Defender plans for Servers, Storage, SQL, and Containers
- Extend Defender for Cloud to hybrid servers with Azure Arc
- Connect AWS and GCP environments for multicloud posture coverage
- Deploy a Log Analytics workspace and onboard Microsoft Sentinel
- Configure Sentinel connectors and analytics rules
- Extend Sentinel with AMA, DCR, Content hub solutions, and richer data ingestion
- Write basic KQL queries for threat hunting
- Understand SIEM vs SOAR, Sentinel playbooks, automation rules, and Logic Apps security
- Triage incidents and pivot through entities with KQL
- Configure Microsoft Security Copilot roles, plugin access, and agent setup basics

---

## Module Overview

Security Operations is about **detecting, investigating, and responding** to threats across your Azure environment. Defender for Cloud provides posture management and workload protection; Sentinel provides SIEM/SOAR capabilities.

### Mapped SC-500 Skill Areas

This module primarily maps to **Manage and monitor security posture (20-25%)** in the official SC-500 study guide. Expect questions on:
- Defender for Cloud plans and what each protects
- Secure Score: what it measures and how to improve it
- Sentinel workspace deployment and connector types
- KQL query syntax (basic queries on SecurityEvent, SigninLogs, etc.)
- Analytics rule types (Scheduled, NRT, Fusion, ML)
- Playbooks and Logic Apps integration
- Security Copilot roles, plugin dependencies, and agent setup boundaries

---

## Labs in This Module

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-defender-cloud.md` | Enable Defender for Cloud, review Secure Score | 45–60 min |
| `lab-02-sentinel-setup.md` | Deploy Sentinel, connectors, analytics rules, KQL | 60–90 min |
| `lab-04-sentinel-ingestion-dcr.md` | Extend ingestion with AMA, DCR, and Content hub | 60–90 min |
| `lab-03-sentinel-triage-investigation.md` | Triage an incident and investigate with KQL | 60–90 min |
| `lab-05-sentinel-automation-playbooks.md` | Build automation rules and trigger playbooks | 60–90 min |
| `lab-06-logic-apps-security-for-playbooks.md` | Secure playbook identity and permissions | 45–60 min |
| `lab-07-defender-cloud-hybrid-arc.md` | Onboard a hybrid server with Azure Arc and Defender for Servers | 60–90 min |
| `lab-08-defender-cloud-multicloud-connectors.md` | Connect AWS/GCP and compare CSPM vs CWPP coverage | 60–90 min |
| `lab-09-security-copilot-agents.md` | Assign Copilot roles, validate plugin RBAC, and set up a small Security Copilot agent path | 30–45 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/log-analytics-workspace.json` | ARM template — Log Analytics workspace |
| `templates/sentinel-workspace.json` | ARM template — Sentinel on existing workspace |

---

## Key Microsoft Learn Links

- [Mitigate threats using Defender for Cloud](https://learn.microsoft.com/en-us/training/paths/sc-200-mitigate-threats-using-azure-defender/)
- [Secure your hybrid and multicloud machines by using Azure Arc-enabled servers](https://learn.microsoft.com/en-us/training/modules/secure-azure-arc-enabled-servers/)
- [Introduction to Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-sentinel/)
- [Kusto Query Language overview for Microsoft Sentinel](https://learn.microsoft.com/en-us/kusto/query/kusto-sentinel-overview?toc=%2Fazure%2Fsentinel%2FTOC.json&bc=%2Fazure%2Fsentinel%2Fbreadcrumb%2Ftoc.json)
- [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/)
- [Deploy and manage Microsoft Sentinel out-of-the-box content](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-solutions-deploy)
- [Automate threat response with Microsoft Sentinel playbooks](https://learn.microsoft.com/en-us/azure/sentinel/automation/automate-responses-with-playbooks)
- [Get started with Microsoft Security Copilot](https://learn.microsoft.com/en-us/copilot/security/get-started-security-copilot)
- [Understand authentication in Microsoft Security Copilot](https://learn.microsoft.com/en-us/copilot/security/authentication)

---

## Start Here

1. Read `study-guide.md` — understand Defender for Cloud plans and Sentinel architecture
2. Complete `lab-01-defender-cloud.md` — enable Defender and review Secure Score
3. Complete `lab-02-sentinel-setup.md` — deploy Sentinel and write KQL queries
4. Complete `lab-04-sentinel-ingestion-dcr.md` — add AMA + DCR-based event collection
5. Complete `lab-03-sentinel-triage-investigation.md` — investigate a likely account compromise path
6. Complete `lab-05-sentinel-automation-playbooks.md` — automate a simple incident response path
7. Complete `lab-06-logic-apps-security-for-playbooks.md` — secure playbook identity and permissions
8. Complete `lab-09-security-copilot-agents.md` — validate Security Copilot roles, plugins, and a small agent setup flow
9. Complete `lab-07-defender-cloud-hybrid-arc.md` — extend server posture beyond Azure-only scope
10. Complete `lab-08-defender-cloud-multicloud-connectors.md` — compare AWS/GCP posture coverage and plan choices
11. Deploy templates via ARM for practice with IaC
