# SC-500 Lab Matrix

Use this matrix to estimate prerequisites, cost, and time before starting a lab.

| Lab | Azure subscription | Entra P1/P2 | M365 / Purview | Estimated cost risk | Estimated time |
| --- | --- | --- | --- | --- | --- |
| `01-identity-governance/lab-02-conditional-access.md` | Optional | P1/P2 | No | Low | 60-90 min |
| `01-identity-governance/lab-03-pim-access-governance.md` | No | P2 | No | Low | 60-90 min |
| `01-identity-governance/lab-04-workload-identities.md` | Yes | No | No | Low | 60-90 min |
| `01-identity-governance/lab-05-enterprise-app-governance.md` | No | Recommended | No | Low | 60-90 min |
| `02-platform-protection/lab-01-network-security.md` | Yes | No | No | Medium | 60-90 min |
| `02-platform-protection/lab-02-waf-setup.md` | Yes | No | No | Medium-High | 90-120 min |
| `02-platform-protection/lab-03-private-access-patterns.md` | Yes | No | No | Medium | 60-90 min |
| `02-platform-protection/lab-04-vm-security.md` | Yes | No | No | Medium | 60-90 min |
| `02-platform-protection/lab-05-app-platform-security.md` | Yes | No | No | Medium | 60-90 min |
| `03-security-operations/lab-01-defender-cloud.md` | Yes | No | No | Medium | 45-60 min |
| `03-security-operations/lab-02-sentinel-setup.md` | Yes | Optional | No | Medium | 60-90 min |
| `03-security-operations/lab-03-sentinel-triage-investigation.md` | Yes | Optional | No | Medium | 60-90 min |
| `04-data-protection/lab-01-storage-encryption.md` | Yes | No | No | Low-Medium | 45-60 min |
| `04-data-protection/lab-02-database-security.md` | Yes | No | No | Medium | 60-90 min |
| `04-data-protection/lab-03-purview-labels-dlp-dspm.md` | Optional | Optional | Yes | Low-Medium | 60-90 min |
| `05-governance-compliance/lab-01-azure-policy.md` | Yes | No | No | Low | 45-60 min |
| `05-governance-compliance/lab-02-compliance-assessment.md` | Yes | No | No | Low | 30-45 min |
| `06-ai-workload-security/lab-01-ai-gateway.md` | Yes | Optional | Optional | High | 60-90 min |
| `06-ai-workload-security/lab-02-purview-dspm-copilot.md` | No | No | Yes | Low-Medium | 45-60 min |
| `06-ai-workload-security/lab-03-entra-agent-id.md` | Optional | Recommended | Optional | Low | 45-60 min |
| `06-ai-workload-security/lab-04-defender-for-ai.md` | Yes | No | Optional | Medium | 45-60 min |

## Interpreting cost risk

- **Low**: little or no incremental cost
- **Medium**: billable Azure resources but manageable if cleaned up promptly
- **High**: services like APIM, WAF, Sentinel, or Defender plans that can add noticeable cost if left running

## Public-use guidance

- Prefer a dedicated lab subscription or resource group
- Set budgets and alerts before starting
- Clean up resources after each lab
- Review licensing needs before attempting Purview, Entra P2, or AI-specific labs
