# SC-500 Study Roadmap: 12-Week Plan

**Audience:** Cloud engineer preparing for **Microsoft Certified: Cloud and AI Security Engineer Associate**
**Exam:** SC-500 - Implementing End-to-End Security Controls for Cloud and AI Workloads
**Pace:** 10-15 hrs/week

## Skill area alignment

This roadmap follows the official SC-500 study guide, not the older AZ-500 domain model.

| Skill area | Weight | Weeks covered |
| --- | ---: | --- |
| Manage identity, access, and governance | 20-25% | 2, 3 |
| Secure storage, databases, and networking | 25-30% | 4, 5, 6 |
| Secure compute (servers, containers, apps, AI) | 20-25% | 7, 8, 9 |
| Manage and monitor security posture | 20-25% | 10, 11 |

## Weekly plan

| Week | Focus | Repo work | Microsoft Learn / Docs | Milestone |
| --- | --- | --- | --- | --- |
| 1 | Orientation and environment | `AZURE-SETUP.md`, `resources/exam-tips.md` | SC-500 study guide, exam sandbox | Lab tenant ready |
| 2 | Identity and access | `01-identity-governance/study-guide.md`, `lab-01`, `lab-02` | Entra ID, MFA/passwordless, Conditional Access, PIM | Explain Entra roles vs Azure RBAC |
| 3 | Foundation resources for later labs | `02-platform-protection/lab-01-network-security.md`, `04-data-protection/lab-01-storage-encryption.md`, `01-identity-governance/lab-04-workload-identities.md` | Managed identities, Key Vault, private endpoints, secure storage | Shared lab environment ready |
| 4 | Database and private access | `04-data-protection/lab-02-database-security.md`, `02-platform-protection/lab-03-private-access-patterns.md` | Azure SQL, TDE, Always Encrypted, Private Link, DNS | SQL + private-only access working |
| 5 | Identity governance and app identity | `01-identity-governance/`, `05-governance-compliance/` | App registrations, OAuth consent, PIM, Access Reviews, Azure Policy | Secure app identity and governance controls |
| 6 | Network security extras | `02-platform-protection/lab-02-waf-setup.md` | NSG, ASG, Azure Firewall, WAF, Virtual WAN, Entra Private Access | Choose NSG vs Firewall vs WAF |
| 7 | Compute: servers and VMs | Extend `02-platform-protection/` with VM/Bastion/JIT | Disk encryption, Bastion, JIT, Arc, Defender for Servers, secure boot, vTPM | Secure VM without public RDP/SSH |
| 8 | Compute: containers, apps, APIs | Notes in `02-platform-protection/`, app service and APIM references | AKS, ACR, Container Apps, Functions, Logic Apps, App Service, WAF, APIM policies | Explain secure app platform controls |
| 9 | AI workload security | `06-ai-workload-security/` all labs | Foundry, AI Gateway in APIM, Purview DSPM for AI, Defender for AI Service, Entra Agent ID, Copilot Studio | Secure an end-to-end AI workload |
| 10 | Posture: Defender for Cloud | `03-security-operations/lab-01-defender-cloud.md`, `05-governance-compliance/` | Defender CSPM, workload plans, EASM, AWS/GCP connectors, Defender Vulnerability Management | Prioritize posture risks |
| 11 | Sentinel + Security Copilot | `03-security-operations/lab-02-sentinel-setup.md` | Sentinel workspaces, connectors, DCRs, automation, Security Copilot roles/plugins | Investigate with KQL |
| 12 | Exam readiness | Weak labs redo, all self-checks | Practice assessment on Microsoft Learn, exam sandbox | Consistent 80%+ practice scores |

## Session template (2-3 hours)

1. **10 min** - Read the SC-500 skill bullet you are targeting from `README.md`.
2. **35 min** - Study the linked Microsoft Learn / Docs page.
3. **60-90 min** - Complete the hands-on task in Azure or Microsoft 365.
4. **20 min** - Validate: logs, portal evidence, Defender recommendation, or KQL.
5. **15 min** - Write "Why this control? What are the distractor answers?" in your study notes.

## Shared lab environment guidance

For the smoothest first pass, keep these resources alive across multiple weeks:

- `vnet-sc500-lab`
- `kv-sc500-lab`
- the storage account from Domain 4 Lab 01
- the SQL server from Domain 4 Lab 02
- one test VM for JIT / Defender / private DNS checks

Delete them after Week 6 or after you finish the dependent labs, not immediately after the first lab that created them.

## Lab evidence to record

Every lab should end with a short note:

- Requirement: what security outcome was needed?
- Control: what Microsoft service or feature implemented it?
- Scope: tenant, subscription, resource group, resource, data plane, or app?
- Validation: how did you prove it works?
- Cleanup: what remains behind (policies, keys, assignments, diagnostic settings)?
- Exam trap: what plausible-but-wrong answer would appear on the exam?

## AI security readiness checklist

Ready when you can:

- Explain what AI Gateway in Azure API Management does for Microsoft Foundry.
- Compare Foundry guardrails vs API Management policies vs Defender for AI Service.
- Describe Microsoft Purview DSPM for AI and how it complements DLP.
- Secure Microsoft Entra Agent ID with Conditional Access and blast-radius analysis in Defender XDR.
- Know when Security Copilot helps and what workspaces/plugins/permissions it needs.

## Final readiness rules

Do not book the exam until:

- You have scored 80%+ on the Microsoft Learn practice assessment twice.
- You can explain every wrong answer in your own words.
- You have completed every module lab at least once and re-run the weakest ones.
- You reviewed the official study guide within the last 7 days.

## Next step

Go to Week 1: complete `AZURE-SETUP.md`, then start Week 2. Optionally use the **SC-500 Coach** agent for a first-session teach-block on PIM.
