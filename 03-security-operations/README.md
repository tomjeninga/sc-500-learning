# Domain 3: Security Operations

## Learning Objectives

By completing this domain, you will be able to:

- Enable and configure Microsoft Defender for Cloud
- Understand and improve Secure Score
- Enable Defender plans for Servers, Storage, SQL, and Containers
- Deploy a Log Analytics workspace and onboard Microsoft Sentinel
- Configure Sentinel connectors and analytics rules
- Write basic KQL queries for threat hunting
- Understand SIEM vs SOAR, Sentinel playbooks, and automation rules

---

## Domain Overview

Security Operations is about **detecting, investigating, and responding** to threats across your Azure environment. Defender for Cloud provides posture management and workload protection; Sentinel provides SIEM/SOAR capabilities.

### SC-500 Exam Weight: ~20–25%

Expect questions on:
- Defender for Cloud plans and what each protects
- Secure Score: what it measures and how to improve it
- Sentinel workspace deployment and connector types
- KQL query syntax (basic queries on SecurityEvent, SigninLogs, etc.)
- Analytics rule types (Scheduled, NRT, Fusion, ML)
- Playbooks and Logic Apps integration

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-defender-cloud.md` | Enable Defender for Cloud, review Secure Score | 45–60 min |
| `lab-02-sentinel-setup.md` | Deploy Sentinel, connectors, analytics rules, KQL | 60–90 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/log-analytics-workspace.json` | ARM template — Log Analytics workspace |
| `templates/sentinel-workspace.json` | ARM template — Sentinel on existing workspace |

---

## Key Microsoft Learn Links

- [Mitigate threats using Defender for Cloud](https://learn.microsoft.com/en-us/training/paths/sc-200-mitigate-threats-using-azure-defender/)
- [Introduction to Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-sentinel/)
- [Create KQL queries for Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/construct-kql-statements-microsoft-sentinel/)
- [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/)

---

## Start Here

1. Read `study-guide.md` — understand Defender for Cloud plans and Sentinel architecture
2. Complete `lab-01-defender-cloud.md` — enable Defender and review Secure Score
3. Complete `lab-02-sentinel-setup.md` — deploy Sentinel and write KQL queries
4. Deploy templates via ARM for practice with IaC
