# SC-500 Study Roadmap: 12-Week Plan

**Audience:** Cloud Platform Engineer | **Pace:** 10–15 hrs/week | **Sessions:** 2–3 hrs, 4–5 sessions/week

---

## Overview

| Phase | Weeks | Focus |
|-------|-------|-------|
| Foundation | 1–2 | Environment setup + Identity & Governance theory |
| Build | 3–6 | Platform Protection + Security Operations |
| Depth | 7–10 | Data Protection + Governance/Compliance |
| Exam Prep | 11–12 | Review, practice exams, weak-area focus |

---

## Week 1 — Environment Setup & SC-500 Orientation

**Goal:** Get your Azure environment ready and understand the exam structure.

**Sessions (2–3 hrs each):**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `AZURE-SETUP.md`, create free-tier subscription | `AZURE-SETUP.md` |
| 2 | Install Az CLI, Az PowerShell, configure `rg-sc500-lab` | `AZURE-SETUP.md` |
| 3 | Read `README.md` and `resources/exam-tips.md` | This repo |
| 4 | Microsoft Learn: [SC-500 study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500) | Microsoft Learn |

**Milestone:** Azure subscription ready, tools installed, study plan confirmed.

**Self-assessment:**
- [ ] Can you create a resource group with Az PowerShell?
- [ ] Do you understand the 5 exam domains and their rough weightings?

---

## Week 2 — Identity & Governance: Theory

**Goal:** Master Entra ID, RBAC, Conditional Access, PIM, and MFA concepts.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `01-identity-governance/study-guide.md` (full) | This repo |
| 2 | MS Learn: [Manage identities in Azure AD](https://learn.microsoft.com/en-us/training/modules/manage-identities-microsoft-entra-id/) | Microsoft Learn |
| 3 | MS Learn: [Configure RBAC](https://learn.microsoft.com/en-us/training/modules/configure-role-based-access-control/) | Microsoft Learn |
| 4 | MS Learn: [Protect identities with Azure AD](https://learn.microsoft.com/en-us/training/modules/protect-identities-with-aad-idp/) | Microsoft Learn |
| 5 | Review `resources/glossary.md` — identity terms | This repo |

**Milestone:** Understand the difference between RBAC roles, Entra ID roles, and PIM.

**Self-assessment:**
- [ ] What is the difference between Owner, Contributor, and Reader roles?
- [ ] How does Privileged Identity Management (PIM) differ from permanent role assignment?
- [ ] What triggers a Conditional Access policy evaluation?

---

## Week 3 — Identity & Governance: Labs

**Goal:** Build hands-on identity security controls.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Lab: `01-identity-governance/lab-01-entra-id-setup.md` (Portal steps) | This repo |
| 2 | Lab: Deploy via ARM template (`templates/rbac-assignments.json`) | This repo |
| 3 | Lab: `01-identity-governance/lab-02-conditional-access.md` | This repo |
| 4 | Review + run `scripts/setup-entra-id-lab.ps1` | This repo |
| 5 | Practice questions on Domain 1 | `resources/exam-tips.md` |

**Milestone:** Created users/groups, assigned RBAC, created Conditional Access policies.

**Checkpoint Self-Assessment:**
- [ ] Can you explain when Conditional Access policies are evaluated?
- [ ] What is a Privileged Access Workstation (PAW) and why does it matter?
- [ ] How do you enable MFA for a specific group in Entra ID?

---

## Week 4 — Platform Protection: Theory

**Goal:** Master network security, WAF, encryption in transit/at rest.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `02-platform-protection/study-guide.md` | This repo |
| 2 | MS Learn: [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/) | Microsoft Learn |
| 3 | MS Learn: [Introduction to Azure Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/) | Microsoft Learn |
| 4 | MS Learn: [Secure network connectivity on Azure](https://learn.microsoft.com/en-us/training/modules/secure-network-connectivity-azure/) | Microsoft Learn |
| 5 | Review NSG vs Firewall vs WAF comparison table in study guide | This repo |

**Milestone:** Understand the layered network defence model in Azure.

**Self-assessment:**
- [ ] What is the difference between NSG and Azure Firewall?
- [ ] When should you use Azure DDoS Standard vs Basic?
- [ ] What is a Private Endpoint and how does it differ from a Service Endpoint?

---

## Week 5 — Platform Protection: Labs

**Goal:** Build network security controls and a WAF.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Lab: `02-platform-protection/lab-01-network-security.md` (Portal) | This repo |
| 2 | Deploy `templates/vnet-with-nsg.json` via ARM | This repo |
| 3 | Lab: `02-platform-protection/lab-02-waf-setup.md` | This repo |
| 4 | Run `scripts/deploy-network-lab.ps1`, review WAF logs | This repo |
| 5 | Cleanup + practice questions Domain 2 | `resources/exam-tips.md` |

**Milestone:** Deployed VNet with NSGs, App Gateway WAF with OWASP ruleset.

**Checkpoint Self-Assessment:**
- [ ] How do you block all inbound traffic except port 443 using an NSG?
- [ ] What OWASP ruleset version is recommended for Azure WAF?
- [ ] What is Azure Bastion and why avoid exposing RDP/SSH to internet?

---

## Week 6 — Security Operations: Theory

**Goal:** Master Defender for Cloud, Secure Score, Microsoft Sentinel, and KQL basics.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `03-security-operations/study-guide.md` | This repo |
| 2 | MS Learn: [Mitigate threats using Defender for Cloud](https://learn.microsoft.com/en-us/training/paths/sc-200-mitigate-threats-using-azure-defender/) | Microsoft Learn |
| 3 | MS Learn: [Introduction to Microsoft Sentinel](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-sentinel/) | Microsoft Learn |
| 4 | MS Learn: [KQL basics for Sentinel](https://learn.microsoft.com/en-us/training/modules/construct-kql-statements-microsoft-sentinel/) | Microsoft Learn |
| 5 | Review KQL query examples in study guide | This repo |

**Milestone:** Understand SIEM vs SOAR, Secure Score mechanics, analytics rule types.

**Self-assessment:**
- [ ] What is the difference between Defender for Cloud and Microsoft Sentinel?
- [ ] Write a KQL query to find all sign-in failures in the last 24 hours.
- [ ] What are the four types of analytics rules in Sentinel?

---

## Week 7 — Security Operations: Labs

**Goal:** Enable Defender for Cloud and deploy Sentinel with connectors and analytics rules.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Lab: `03-security-operations/lab-01-defender-cloud.md` | This repo |
| 2 | Lab: Deploy `templates/log-analytics-workspace.json` | This repo |
| 3 | Lab: `03-security-operations/lab-02-sentinel-setup.md` | This repo |
| 4 | Deploy `templates/sentinel-workspace.json`, create analytics rule | This repo |
| 5 | Practice KQL queries, review Secure Score recommendations | This repo |

**Milestone:** Deployed Sentinel with connectors, created a scheduled analytics rule, ran KQL queries.

**Checkpoint Self-Assessment:**
- [ ] What Log Analytics table stores Azure Activity logs?
- [ ] How do you create an automation rule that triggers a playbook in Sentinel?
- [ ] What Defender for Cloud plan protects Azure VMs?

---

## Week 8 — Data Protection: Theory

**Goal:** Master storage encryption, Key Vault, SQL security, Purview/MIP, sensitivity labels.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `04-data-protection/study-guide.md` | This repo |
| 2 | MS Learn: [Configure Azure Key Vault](https://learn.microsoft.com/en-us/training/modules/configure-and-manage-azure-key-vault/) | Microsoft Learn |
| 3 | MS Learn: [Encrypt Azure Storage](https://learn.microsoft.com/en-us/training/modules/secure-azure-storage-account/) | Microsoft Learn |
| 4 | MS Learn: [Secure your Azure SQL Database](https://learn.microsoft.com/en-us/training/modules/secure-your-azure-sql-database/) | Microsoft Learn |
| 5 | Review CMK vs PMK comparison table | This repo |

**Milestone:** Understand encryption at rest, in transit, Always Encrypted, and the Purview ecosystem.

**Self-assessment:**
- [ ] What is the difference between CMK and PMK?
- [ ] How does Always Encrypted differ from TDE?
- [ ] What is a sensitivity label and how does it interact with DLP?

---

## Week 9 — Data Protection: Labs

**Goal:** Implement storage CMK encryption, SQL security controls, and database auditing.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Lab: `04-data-protection/lab-01-storage-encryption.md` | This repo |
| 2 | Deploy `templates/storage-account-encrypted.json` | This repo |
| 3 | Lab: `04-data-protection/lab-02-database-security.md` | This repo |
| 4 | Deploy `templates/sql-database-secured.json`, test Entra auth | This repo |
| 5 | Cleanup + practice questions Domain 4 | `resources/exam-tips.md` |

**Milestone:** Storage with CMK, SQL with TDE + Entra auth + auditing + Defender for SQL.

**Checkpoint Self-Assessment:**
- [ ] How do you rotate a CMK without data loss?
- [ ] What Azure service provides sensitive data discovery and classification?
- [ ] How does Defender for SQL detect SQL injection attacks?

---

## Week 10 — Governance & Compliance: Theory + Labs

**Goal:** Master Azure Policy, Management Groups, Regulatory Compliance dashboard.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Read `05-governance-compliance/study-guide.md` | This repo |
| 2 | MS Learn: [Govern Azure subscriptions with Azure Policy](https://learn.microsoft.com/en-us/training/modules/intro-to-governance/) | Microsoft Learn |
| 3 | Lab: `05-governance-compliance/lab-01-azure-policy.md` | This repo |
| 4 | Deploy `templates/azure-policy-definitions.json` | This repo |
| 5 | Lab: `05-governance-compliance/lab-02-compliance-assessment.md` | This repo |

**Milestone:** Created custom deny policies, assigned initiative, reviewed compliance dashboard.

**Checkpoint Self-Assessment:**
- [ ] What is the difference between Audit and Deny policy effects?
- [ ] How do Management Groups relate to subscriptions?
- [ ] What is a regulatory compliance initiative in Defender for Cloud?

---

## Week 11 — Full Review + Practice Exams

**Goal:** Identify weak areas and fill gaps before the exam.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Review `resources/exam-tips.md` — question type strategies | This repo |
| 2 | Take full practice exam (MeasureUp or Whizlabs) | `resources/exam-tips.md` |
| 3 | Review wrong answers — map to domain study guides | This repo |
| 4 | Re-read weak domain study guides | This repo |
| 5 | Second practice exam + review | `resources/exam-tips.md` |

**Milestone:** Scoring 75%+ on practice exams consistently.

**Self-assessment:**
- [ ] Which domain has the most questions?
- [ ] Are you confident with KQL query writing?
- [ ] Do you know the difference between Sentinel analytics rule types?

---

## Week 12 — Final Exam Prep & Exam Day

**Goal:** Fine-tune and pass SC-500.

**Sessions:**

| Day | Activity | Resource |
|-----|----------|----------|
| 1 | Review `resources/glossary.md` — any unfamiliar terms? | This repo |
| 2 | Review all self-check questions across domains | This repo |
| 3 | Final practice exam | `resources/exam-tips.md` |
| 4 | Light review only — rest before exam | — |
| 5 | **EXAM DAY** 🎓 | — |

**Milestone:** SC-500 certification earned! 🏆

---

## Microsoft Learn Learning Paths (Exam-Aligned)

| Learning Path | Domain |
|---------------|--------|
| [SC-500: Implement identity and access management](https://learn.microsoft.com/en-us/training/paths/implement-identity-access-management/) | Domain 1 |
| [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/) | Domain 2 |
| [SC-500: Manage security operations](https://learn.microsoft.com/en-us/training/paths/manage-security-operations/) | Domain 3 |
| [SC-500: Secure data and applications](https://learn.microsoft.com/en-us/training/paths/secure-data-applications/) | Domain 4 |
| [SC-500: Manage governance and compliance](https://learn.microsoft.com/en-us/training/paths/governance-compliance-azure-security/) | Domain 5 |

---

## Weekly Time Budget (10–15 hrs/week)

```
Session 1: 2.5 hrs  ─ Theory reading + note-taking
Session 2: 2.5 hrs  ─ Microsoft Learn module
Session 3: 3.0 hrs  ─ Hands-on lab (Portal)
Session 4: 2.5 hrs  ─ ARM template / PowerShell automation
Session 5: 2.0 hrs  ─ Practice questions + review
─────────────────────
Total:    12.5 hrs/week
```

---

*Next Step:* Read `AZURE-SETUP.md` and complete your environment setup before beginning Week 1.
