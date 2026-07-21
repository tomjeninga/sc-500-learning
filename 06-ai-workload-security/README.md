# Domain 6: AI Workload Security

New SC-500 territory. This is the module the older AZ-500 style repos are missing. Master this and you have a real edge on the exam.

## SC-500 skill mapping

From skill area 3 (Secure compute) - "Implement security for AI":

- Identify overexposure of data in SharePoint
- Identify Copilot/AI app risks using Microsoft Purview Data Security Posture Management (DSPM)
- Enable real-time protection for Microsoft Copilot Studio agents
- Implement Conditional Access for Microsoft Entra Agent ID
- Analyze blast radius for Entra Agent ID using Microsoft Defender XDR
- Manage Entra Agent ID access
- Configure and deploy AI Gateway in Azure API Management for Microsoft Foundry
- Enable Defender for AI Service in Defender for Cloud
- Configure guardrails for agent security in Foundry
- Monitor AI security with the Data and AI security dashboard in Defender for Cloud
- Manage agents in the Microsoft 365 admin center

## Learning objectives

By completing this module you will be able to:

- Explain the AI security threat model: prompt injection, data exfiltration, model abuse, agent identity blast radius, over-shared source data.
- Design a secure Foundry project with keyless access, private networking, guardrails, and monitoring.
- Deploy an **AI Gateway** in Azure API Management for Foundry-hosted models with token limits, semantic caching, content safety, and observability.
- Configure **Microsoft Purview DSPM for AI** to detect Copilot risks and oversharing.
- Configure **Defender for AI Service** in Defender for Cloud and use the Data and AI security dashboard.
- Secure **Entra Agent ID** with Conditional Access and access reviews, and analyze blast radius in Defender XDR.
- Manage agents in the Microsoft 365 admin center.

## Labs in this domain

| Lab | Topic | Est. time |
| --- | --- | --- |
| `lab-01-ai-gateway.md` | Deploy AI Gateway in APIM for a Foundry model with token limits, content safety, and observability | 90-120 min |
| `lab-02-purview-dspm-copilot.md` | Enable Purview DSPM for AI, discover Copilot risks, act on SharePoint oversharing | 60-90 min |
| `lab-03-entra-agent-id.md` | Register an Entra Agent ID, apply Conditional Access, review blast radius in Defender XDR | 60-90 min |
| `lab-04-defender-for-ai.md` | Enable Defender for AI Service, generate alerts, review Data and AI security dashboard | 45-60 min |

Labs are the primary artifact. Start with the study guide, then run at least the AI Gateway and Purview DSPM labs.

## Study guide

See `study-guide.md` for concepts, comparisons, and exam traps.

## Key Microsoft Learn and Docs links

- Microsoft Foundry: <https://learn.microsoft.com/en-us/azure/ai-foundry/>
- AI Gateway in Azure API Management: <https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities>
- Microsoft Purview DSPM for AI: <https://learn.microsoft.com/en-us/purview/ai-microsoft-purview>
- Microsoft Copilot Studio security and governance: <https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance>
- Microsoft Entra Agent ID: <https://learn.microsoft.com/en-us/entra/identity/agentid/overview>
- Defender for Cloud AI security: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-security>
- Data and AI security dashboard: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/data-aware-security-dashboard-overview>

## Start here

1. Read `study-guide.md`.
2. Complete `lab-01-ai-gateway.md`.
3. Complete `lab-02-purview-dspm-copilot.md`.
4. Complete `lab-03-entra-agent-id.md`.
5. Complete `lab-04-defender-for-ai.md`.
6. Ask the SC-500 Coach for a quiz on AI security exam traps.
