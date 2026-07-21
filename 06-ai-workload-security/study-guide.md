# Module 6 Study Guide: AI Workload Security

This is the newest and most differentiating part of SC-500. Older AZ-500 material will not prepare you for it.

## The mental model

AI security stacks the same layers as any workload, plus AI-specific ones:

1. **Data source security** - where the model or agent reads from (SharePoint, OneDrive, databases). Overshared data becomes overshared answers.
2. **Identity** - user identity (Entra ID), workload identity (Managed Identity), and agent identity (Microsoft Entra Agent ID).
3. **Network** - private endpoints for Foundry, storage, and databases; keyless access; no public endpoints unless required.
4. **Model and API layer** - AI Gateway in APIM in front of models: authentication, token limits, content safety, semantic caching, observability.
5. **Model behavior** - Foundry guardrails and content safety policies for the model or agent.
6. **Posture and detection** - Defender for AI Service, Data and AI security dashboard, Purview DSPM, Defender XDR.
7. **Governance** - agent management in Microsoft 365 admin center, access reviews, conditional access.

Memorize this stack. Most SC-500 AI questions ask which layer the correct control lives in.

## Purview Data Security Posture Management (DSPM) for AI

Purpose: discover, classify, and reduce data exposure risk that surfaces through Microsoft Copilot and AI apps.

Key ideas:

- Detects sensitive data over-exposed to Copilot users because of loose SharePoint or OneDrive sharing.
- Uses sensitivity labels, sensitive info types, and interaction insights.
- Complements DLP: DLP prevents movement, DSPM finds and reduces exposure.
- Reports risky prompts and unethical AI use interactions.

Exam trap: "Which service identifies data overexposure to Microsoft Copilot?" - answer is **Purview DSPM for AI**, not Defender for Cloud, not sensitivity labels alone.

## Defender for AI Service (in Defender for Cloud)

Purpose: threat protection for Azure AI workloads (Foundry, Azure OpenAI style resources).

Key ideas:

- Detects prompt injection attempts and abuse patterns.
- Surfaces alerts in the Data and AI security dashboard.
- Enabled per subscription as a workload protection plan.
- Requires diagnostic settings on the AI resource for full signal.

Exam trap: confusing **Defender for AI Service** (threat protection at runtime) with **Foundry guardrails** (behavior policy at model layer) or **AI Gateway** (perimeter policy).

## AI Gateway in Azure API Management for Microsoft Foundry

Purpose: put an enterprise-grade API perimeter in front of AI models.

Key capabilities:

- Token limit policies (per key, per subscription, per user).
- Semantic caching to reduce token spend.
- Content safety and jailbreak detection through Azure AI Content Safety integration.
- Load balancing across multiple model deployments.
- Emit token metrics and logs to Log Analytics and Application Insights.

Exam trap: "Which service enforces per-user token limits for a Foundry model?" -> **AI Gateway (APIM policy)**, not Foundry guardrails.

## Foundry guardrails

Purpose: shape model and agent behavior inside Foundry.

- Content filters (violence, sexual, hate, self-harm, jailbreak, protected material).
- Grounding and topic restrictions for agents.
- Response formatting and safety metadata.

Exam trap: guardrails do not enforce network isolation or token quotas - those live in APIM AI Gateway or Foundry networking.

## Microsoft Entra Agent ID

Purpose: give AI agents a first-class identity in Entra ID so they can be governed like any principal.

Key ideas:

- Agents get an Agent ID that can be targeted with Conditional Access.
- Access can be reviewed, revoked, and audited.
- Defender XDR can analyze blast radius: what would a compromised agent reach?
- Managed alongside enterprise applications and app registrations.

Exam trap: "How do you restrict a Copilot Studio agent to require compliant devices?" -> **Conditional Access targeting the Entra Agent ID**, not a service principal secret change.

## Microsoft Copilot Studio agent protection

- Enable real-time protection for agents.
- Configure agent permissions and connectors carefully.
- Manage agents from the Microsoft 365 admin center.
- Combine with Purview DSPM for AI to catch data risk.

## Copilot Studio governance and Microsoft 365 admin controls

Copilot Studio governance is broader than prompt blocking.

Key ideas:

- Admins can use **data policies** to govern connectors, triggers, HTTP requests, knowledge sources, and publication paths.
- Makers can see **runtime protection status** and other security warnings before publishing an agent.
- Microsoft 365 admin controls decide which agents or AI actions are available to users in Microsoft 365 surfaces.

Exam trap: if the question is about **which agents users can access in Microsoft 365**, think **Microsoft 365 admin center governance**, not Foundry content filters.

## Foundry guardrails in practice

Foundry guardrails are the model-behavior layer.

Important controls include:

- Harm category thresholds for hate, sexual, violence, and self-harm
- **Prompt shields** for user prompt attacks and indirect attacks
- Optional filters such as:
  - PII
  - Protected material
  - Groundedness

### Guardrails vs other AI controls

| Control | Primary job |
| --- | --- |
| Foundry guardrails | Shape prompts and completions |
| APIM AI Gateway | Token limits, perimeter policy, gateway logging |
| Defender for AI Service | Threat detections and dashboard alerts |
| Entra Agent ID | Identity, CA, and blast-radius governance |

> **Exam tip:** Foundry guardrails can block or annotate unsafe prompts and completions. They do not replace APIM token governance or Defender detections.

## Data and AI security dashboard (Defender for Cloud)

Central view for AI workload posture and alerts. Pulls from Defender for AI Service, Purview signals, and Defender CSPM.

## Comparisons you must know

| If the question says... | The right control is often... |
| --- | --- |
| Overshared SharePoint data reaching Copilot | Purview DSPM for AI + sensitivity labels + SharePoint access review |
| Runtime prompt injection detection on Foundry | Defender for AI Service in Defender for Cloud |
| Per-user token quotas for a model | AI Gateway policy in Azure API Management |
| Block violent/sexual content in outputs | Foundry content filters (guardrails) + Azure AI Content Safety |
| Compromised agent reach analysis | Entra Agent ID + Defender XDR blast radius |
| Require compliant device for an agent | Conditional Access targeting Entra Agent ID |
| Central AI posture and alerts view | Data and AI security dashboard in Defender for Cloud |
| Manage which agents users can install | Microsoft 365 admin center - agent management |
| Limit what connectors, triggers, or actions an agent can use | Copilot Studio governance and Power Platform data policies |

## Self-check questions

1. What is the difference between Foundry guardrails and AI Gateway policies?
2. Which product identifies data over-exposure to Microsoft Copilot?
3. How do you enforce Conditional Access on an autonomous agent?
4. Which dashboard aggregates AI security posture in Defender for Cloud?
5. Which two Defender products cooperate to analyze agent blast radius?
6. Where do you enable real-time protection for Copilot Studio agents?
7. Which layer detects prompt injection attempts against a Foundry model?
8. Why is Purview DSPM for AI not a replacement for DLP?
9. Which admin surface governs which agents or AI actions are available to Microsoft 365 users?
10. Which Foundry feature helps detect user prompt attacks and indirect prompt attacks?

## References

- Microsoft Foundry: <https://learn.microsoft.com/en-us/azure/ai-foundry/>
- AI Gateway in APIM: <https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities>
- Microsoft Purview DSPM for AI: <https://learn.microsoft.com/en-us/purview/ai-microsoft-purview>
- Microsoft Copilot Studio security and governance: <https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance>
- Microsoft Entra Agent ID: <https://learn.microsoft.com/en-us/entra/identity/agentid/overview>
- Defender for Cloud AI security: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-security>
- Foundry content filtering: <https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/content-filtering>
- Data and AI security dashboard: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/data-aware-security-dashboard-overview>
