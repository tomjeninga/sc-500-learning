# SC-500 Lab Matrix

Use this matrix to estimate prerequisites, cost, and time before starting a lab.

## Recommended Order / Dependency Map

If you want the smoothest first pass, build and reuse a small shared lab environment instead of fully cleaning up after every lab:

1. `02-platform-protection/lab-01-network-security.md`
   Creates the shared VNet and subnets.
2. `04-data-protection/lab-01-storage-encryption.md`
   Creates the shared Key Vault and storage account.
3. `01-identity-governance/lab-04-workload-identities.md`
   Reuses the Key Vault and storage account.
4. `04-data-protection/lab-02-database-security.md`
   Creates the SQL resources reused by private access testing.
5. `02-platform-protection/lab-03-private-access-patterns.md`
   Reuses the VNet, storage account, and SQL resources.
6. `02-platform-protection/lab-04-vm-security.md` -> `03-security-operations/lab-01-defender-cloud.md`
   Useful sequence if you want Defender for Cloud findings on a real VM.
7. `02-platform-protection/lab-03-private-access-patterns.md` -> `02-platform-protection/lab-08-network-breadth-validation.md`
   Use the existing VNet, VM, and private-access context to close the remaining network-control bullets with minimal extra cost.
8. `02-platform-protection/lab-05-app-platform-security.md` -> `02-platform-protection/lab-06-aks-acr-defender-containers.md` -> `02-platform-protection/lab-07-logic-apps-and-apim-security.md`
   Start with the broad app-platform controls, then add container security and finally workflow/API enforcement.
9. `03-security-operations/lab-02-sentinel-setup.md` -> `03-security-operations/lab-04-sentinel-ingestion-dcr.md` -> `03-security-operations/lab-03-sentinel-triage-investigation.md` -> `03-security-operations/lab-05-sentinel-automation-playbooks.md` -> `03-security-operations/lab-06-logic-apps-security-for-playbooks.md`
   Keep the same Sentinel workspace through the whole operations sequence.
10. `03-security-operations/lab-02-sentinel-setup.md` -> `03-security-operations/lab-09-security-copilot-agents.md`
   Use the Sentinel workspace as the easiest way to prove that Copilot platform roles and plugin data roles are separate.
11. `03-security-operations/lab-01-defender-cloud.md` -> `03-security-operations/lab-07-defender-cloud-hybrid-arc.md` -> `03-security-operations/lab-08-defender-cloud-multicloud-connectors.md`
   Build from Azure-only posture into hybrid and then multicloud coverage.
12. `05-governance-compliance/lab-01-azure-policy.md` -> `05-governance-compliance/lab-03-rbac-locks-backup-iac.md` -> `05-governance-compliance/lab-02-compliance-assessment.md`
   Start with policy, then add RBAC/lock/backup governance depth, then review the compliance outcome.
13. `06-ai-workload-security/lab-01-ai-gateway.md` -> `06-ai-workload-security/lab-03-entra-agent-id.md` -> `06-ai-workload-security/lab-04-defender-for-ai.md` -> `06-ai-workload-security/lab-05-agent-governance-guardrails.md`
   Build from AI perimeter and identity into runtime detections and then the admin and guardrail governance layer.

Treat `vnet-sc500-lab`, `kv-sc500-lab`, the storage account, the SQL server, and any test VM as shared resources for a study block. Clean them up after the last lab that depends on them, not immediately after they are created.

## Dependency Table

| Lab | Creates | Reuses | Delete after |
| --- | --- | --- | --- |
| `02-platform-protection/lab-01-network-security.md` | `vnet-sc500-lab`, subnets, NSGs | `rg-sc500-lab` | Storage, private access, and any later VNet-based validation are complete |
| `04-data-protection/lab-01-storage-encryption.md` | `kv-sc500-lab`, `storage-cmk-key`, storage account, `pe-storage-sc500` | `vnet-sc500-lab`, `snet-data` | Workload identities, private access, and any optional CMK reuse are complete |
| `01-identity-governance/lab-04-workload-identities.md` | `mi-sc500-workload`, role assignments, test secret | `kv-sc500-lab`, storage account | Managed identity validation is complete |
| `04-data-protection/lab-02-database-security.md` | Azure SQL server, `sqldb-sc500-lab`, auditing/configuration state | `rg-sc500-lab`, optional `law-sc500-sentinel` | Private access testing and any SQL audit review are complete |
| `02-platform-protection/lab-03-private-access-patterns.md` | `pe-sql-sc500`, private DNS links, lockdown settings | `vnet-sc500-lab`, storage account, Azure SQL server, test VM | Storage and SQL private connectivity validation are complete |
| `02-platform-protection/lab-04-vm-security.md` | Trusted launch / JIT / Defender for Servers configuration on a test VM | Existing or newly created test VM | Defender for Cloud follow-up and VM security validation are complete |
| `02-platform-protection/lab-08-network-breadth-validation.md` | Network Watcher validation notes, optional Azure Firewall policy object, decision evidence for Virtual WAN, VPN, Entra Private Access, and Private Link service | `vnet-sc500-lab`, existing VM or NIC, optional private-access context from lab 03 | Network-control breadth review is complete and you no longer need the temporary firewall policy object |
| `02-platform-protection/lab-05-app-platform-security.md` | App or function auth settings, access restrictions, container app ingress settings, optional APIM baseline | `rg-sc500-lab`, optional managed identity or Key Vault setup | Deeper container or API-enforcement follow-up labs are complete |
| `02-platform-protection/lab-06-aks-acr-defender-containers.md` | AKS cluster, ACR security baseline, Defender for Containers plan state | Defender for Cloud subscription setup, optional VNet or workload identity concepts | Container findings review is complete and you no longer need the cluster or registry |
| `02-platform-protection/lab-07-logic-apps-and-apim-security.md` | Logic App workflow hardening, APIM policy enforcement, backend trust-path evidence | Existing App Service or Function App, optional APIM instance | Workflow and API policy validation are complete |
| `03-security-operations/lab-01-defender-cloud.md` | Defender plan state, secure score review, remediation evidence | Test VM, `rg-sc500-lab` | Posture review is complete and paid Defender plans are disabled if no longer needed |
| `03-security-operations/lab-02-sentinel-setup.md` | `law-sc500-sentinel`, Sentinel onboarding, connectors, analytics rule | `rg-sc500-lab`, Azure Activity, Entra logs | Sentinel triage and any optional log reuse are complete |
| `03-security-operations/lab-04-sentinel-ingestion-dcr.md` | AMA + DCR ingestion path, optional solution install, richer event stream | `law-sc500-sentinel`, test VM or forwarder | Triage, automation, and later hunting no longer need the extra source data |
| `03-security-operations/lab-03-sentinel-triage-investigation.md` | Investigation notes, incident triage state, KQL findings | `law-sc500-sentinel`, analytics rule, ingested logs | Investigation is complete and you no longer need the workspace for follow-up |
| `03-security-operations/lab-05-sentinel-automation-playbooks.md` | Automation rule, incident playbook, response workflow evidence | `law-sc500-sentinel`, existing incident or analytics rule | Playbook testing is complete and you no longer need automated incident actions |
| `03-security-operations/lab-06-logic-apps-security-for-playbooks.md` | Managed identity hardening, least-privilege playbook access, connector review | Existing Sentinel playbook | Playbook security validation is complete |
| `03-security-operations/lab-09-security-copilot-agents.md` | Copilot role assignment evidence, plugin dependency validation, small agent setup notes | `law-sc500-sentinel`, Security Copilot tenant access, optional existing incidents or detections | Security Copilot validation is complete and you no longer need the temporary Copilot assignments or test agent |
| `03-security-operations/lab-07-defender-cloud-hybrid-arc.md` | Azure Arc-enabled server resource, hybrid inventory coverage, Defender for Servers on non-Azure machine | Defender for Cloud subscription setup, one non-Azure machine | Hybrid server validation is complete and you no longer need the Arc test machine |
| `03-security-operations/lab-08-defender-cloud-multicloud-connectors.md` | AWS or GCP security connector, plan coverage decisions, multicloud posture evidence | Defender for Cloud subscription setup, optional Arc concepts from lab 07 | Connector validation is complete and you no longer need the cloud environment connected |
| `04-data-protection/lab-03-purview-labels-dlp-dspm.md` | Sensitivity label, label policy, DLP policy, Purview DSPM review context | Microsoft 365 tenant, test collaboration data | Purview DSPM for AI follow-up and label or DLP testing are complete |
| `05-governance-compliance/lab-03-rbac-locks-backup-iac.md` | Custom role example, lock state, backup vault security posture notes, IaC governance evidence | Policy baseline from lab 01, optional Recovery Services vault | Governance validation is complete and you no longer need the temporary role, lock, or vault |
| `06-ai-workload-security/lab-01-ai-gateway.md` | APIM AI Gateway configuration, policy set, diagnostics, AI traffic telemetry | Foundry project, AI Content Safety, Log Analytics, Application Insights | Defender for AI and any AI Gateway testing are complete |
| `06-ai-workload-security/lab-02-purview-dspm-copilot.md` | DSPM for AI findings, mitigation evidence, Copilot overexposure scenario | Purview tenant, Copilot activity, optional labels and DLP setup from `04-data-protection/lab-03` | DSPM validation is complete and you no longer need the test oversharing scenario |
| `06-ai-workload-security/lab-03-entra-agent-id.md` | Agent ID Conditional Access policy, blast-radius review, agent governance evidence | Agent identity, Copilot Studio or equivalent, Defender XDR | Agent security validation is complete |
| `06-ai-workload-security/lab-04-defender-for-ai.md` | Defender for AI enablement, Data and AI security dashboard evidence, AI alerts | AI Gateway or equivalent Foundry deployment, Defender for Cloud, diagnostics | AI alert validation is complete and paid protections are disabled if no longer needed |
| `06-ai-workload-security/lab-05-agent-governance-guardrails.md` | Copilot Studio governance review, M365 agent governance decisions, Foundry content-filter evidence | Foundry deployment, Copilot Studio agent, optional Entra Agent ID and Defender for AI context | AI governance validation is complete and you no longer need the temporary test agent or filter settings |

| Lab | Azure subscription | Entra P1/P2 | M365 / Purview | Estimated cost risk | Estimated time | Reuse guidance |
| --- | --- | --- | --- | --- | --- | --- |
| `01-identity-governance/lab-02-conditional-access.md` | Optional | P1/P2 | No | Low | 60-90 min | Standalone |
| `01-identity-governance/lab-03-pim-access-governance.md` | No | P2 | No | Low | 60-90 min | Standalone |
| `01-identity-governance/lab-04-workload-identities.md` | Yes | No | No | Low | 60-90 min | Reuse Key Vault + Storage from `04-data-protection/lab-01` |
| `01-identity-governance/lab-05-enterprise-app-governance.md` | No | Recommended | No | Low | 60-90 min | Standalone |
| `02-platform-protection/lab-01-network-security.md` | Yes | No | No | Medium | 60-90 min | Keep VNet/subnets for later labs |
| `02-platform-protection/lab-02-waf-setup.md` | Yes | No | No | Medium-High | 90-120 min | Standalone; delete when done |
| `02-platform-protection/lab-03-private-access-patterns.md` | Yes | No | No | Medium | 60-90 min | Reuse VNet + Storage + SQL |
| `02-platform-protection/lab-04-vm-security.md` | Yes | No | No | Medium | 60-90 min | Keep VM if you plan Defender/JIT follow-up |
| `02-platform-protection/lab-08-network-breadth-validation.md` | Yes | Optional | No | Low | 30-45 min | Reuse the VNet and VM from earlier network labs; delete the firewall policy object when done |
| `02-platform-protection/lab-05-app-platform-security.md` | Yes | No | No | Medium | 60-90 min | Reuse apps or access settings for later app-platform labs |
| `02-platform-protection/lab-06-aks-acr-defender-containers.md` | Yes | Optional | No | Medium-High | 60-90 min | Reuse Defender for Cloud setup if you want container findings |
| `02-platform-protection/lab-07-logic-apps-and-apim-security.md` | Yes | Optional | No | Medium | 60-90 min | Reuse App Service, Functions, or APIM from the previous lab |
| `03-security-operations/lab-01-defender-cloud.md` | Yes | No | No | Medium | 45-60 min | Better after VM and Storage labs |
| `03-security-operations/lab-02-sentinel-setup.md` | Yes | Optional | No | Medium | 60-90 min | Reusable workspace for later investigations |
| `03-security-operations/lab-04-sentinel-ingestion-dcr.md` | Yes | Optional | No | Medium | 60-90 min | Reuse Sentinel workspace and keep AMA source only while later labs need it |
| `03-security-operations/lab-03-sentinel-triage-investigation.md` | Yes | Optional | No | Medium | 60-90 min | Reuse Sentinel workspace |
| `03-security-operations/lab-05-sentinel-automation-playbooks.md` | Yes | Optional | No | Low-Medium | 60-90 min | Reuse Sentinel workspace and a test incident path |
| `03-security-operations/lab-06-logic-apps-security-for-playbooks.md` | Yes | Optional | No | Low | 45-60 min | Reuse the playbook from the previous lab |
| `03-security-operations/lab-09-security-copilot-agents.md` | Optional | Optional | Optional | Low-Medium | 30-45 min | Reuse Sentinel workspace and assign only temporary Copilot and plugin roles for validation |
| `03-security-operations/lab-07-defender-cloud-hybrid-arc.md` | Yes | Optional | No | Medium | 60-90 min | Reuse Defender for Cloud setup; keep Arc machine only while validating hybrid posture |
| `03-security-operations/lab-08-defender-cloud-multicloud-connectors.md` | Yes | Optional | No | Medium | 60-90 min | Reuse Defender for Cloud setup; remove connector after study if not needed |
| `04-data-protection/lab-01-storage-encryption.md` | Yes | No | No | Low-Medium | 45-60 min | Keep Key Vault + Storage for later labs |
| `04-data-protection/lab-02-database-security.md` | Yes | No | No | Medium | 60-90 min | Keep SQL for private endpoint lab |
| `04-data-protection/lab-03-purview-labels-dlp-dspm.md` | Optional | Optional | Yes | Low-Medium | 60-90 min | Standalone |
| `05-governance-compliance/lab-01-azure-policy.md` | Yes | No | No | Low | 45-60 min | Standalone unless you want policies left in place |
| `05-governance-compliance/lab-03-rbac-locks-backup-iac.md` | Yes | No | No | Low-Medium | 60-90 min | Reuse subscription governance context and remove temporary locks before cleanup |
| `05-governance-compliance/lab-02-compliance-assessment.md` | Yes | No | No | Low | 30-45 min | Best after policy / Defender posture work |
| `06-ai-workload-security/lab-01-ai-gateway.md` | Yes | Optional | Optional | High | 60-90 min | Standalone; delete promptly |
| `06-ai-workload-security/lab-02-purview-dspm-copilot.md` | No | No | Yes | Low-Medium | 45-60 min | Standalone |
| `06-ai-workload-security/lab-03-entra-agent-id.md` | Optional | Recommended | Optional | Low | 45-60 min | Standalone |
| `06-ai-workload-security/lab-04-defender-for-ai.md` | Yes | No | Optional | Medium | 45-60 min | Better after AI Gateway / Foundry setup |
| `06-ai-workload-security/lab-05-agent-governance-guardrails.md` | Yes | Recommended | Optional | Low-Medium | 60-90 min | Reuse Foundry, Copilot Studio, and agent identity setup from earlier AI labs |

## Interpreting cost risk

- **Low**: little or no incremental cost
- **Medium**: billable Azure resources but manageable if cleaned up promptly
- **High**: services like APIM, WAF, Sentinel, or Defender plans that can add noticeable cost if left running

## Interpreting reuse guidance

- **Standalone**: safe to delete when the lab ends.
- **Keep ... for later labs**: treat the resource as part of your shared lab environment on the first pass.
- **Reusable workspace/resource**: keep it until the follow-up lab is complete.

## Public-use guidance

- Prefer a dedicated lab subscription or resource group
- Set budgets and alerts before starting
- Clean up resources after each lab
- Review licensing needs before attempting Purview, Entra P2, or AI-specific labs
