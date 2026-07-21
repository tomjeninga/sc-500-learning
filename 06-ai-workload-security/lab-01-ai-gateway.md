# Lab 01 - Deploy AI Gateway in Azure API Management for Microsoft Foundry

## SC-500 skill mapping

- Configure and deploy AI Gateway in Azure API Management for Microsoft Foundry
- Enable Defender for AI Service in Cloud Workload Protection in Defender for Cloud
- Monitor AI security by using the Data and AI security dashboard in Defender for Cloud

## Learning objectives

- Front a Microsoft Foundry model with Azure API Management (APIM) as an AI Gateway.
- Apply token limit, content safety, and semantic caching policies.
- Emit token and request metrics to Log Analytics and Application Insights.
- Verify signals appear in Defender for Cloud's Data and AI security dashboard.

## Prerequisites

- Azure subscription with Owner or Contributor + User Access Administrator on `rg-sc500-lab`.
- Defender for Cloud enabled on the subscription.
- A deployed Microsoft Foundry project with at least one model deployment (chat completions).
- Azure API Management instance (Developer tier is enough for lab).
- Azure AI Content Safety resource (for jailbreak/content safety policy).
- Log Analytics workspace and Application Insights.

## Architecture (in words)

Client -> APIM (AI Gateway policies) -> Microsoft Foundry model endpoint. APIM authenticates outbound to Foundry with a managed identity, enforces token limits per subscription key, calls Azure AI Content Safety, caches semantically similar prompts, and emits metrics to App Insights.

## Steps (portal + CLI notes)

1. **Create or reuse APIM instance** in the lab resource group. Enable **system-assigned managed identity**.
1. **Grant APIM managed identity** the appropriate role on the Foundry resource (for example, Cognitive Services User).
1. **Import the Foundry model as an API** in APIM using the built-in "Azure OpenAI/Foundry" import flow. Choose the model deployment.
1. **Configure the back-end** to use managed identity auth to Foundry (no keys in the request).
1. **Attach AI Gateway policies** on the API:
   - `azure-openai-token-limit` or the generative AI token limit policy.
   - `azure-openai-emit-token-metric` to send token usage metrics.
   - `azure-openai-semantic-cache-store` and `azure-openai-semantic-cache-lookup` for semantic caching.
   - Content safety policy calling Azure AI Content Safety for jailbreak and harmful content detection.
1. **Diagnostic settings**: send APIM logs and metrics to Log Analytics and Application Insights.
1. **Enable Defender for AI Service** in Defender for Cloud on the subscription.
1. **Test** with a couple of prompts, including a benign one and a jailbreak attempt.

## Validate

- Call the APIM endpoint with a valid subscription key and confirm the model responds.
- Exceed the token limit and confirm a 429 or policy denial.
- Send a jailbreak-style prompt and confirm it is blocked by the content safety policy.
- Send a similar prompt twice and confirm the second uses the semantic cache (check response time and cache metrics).
- In Log Analytics, query the token metric table to see prompt/completion tokens per operation.
- In Defender for Cloud, open the Data and AI security dashboard and confirm the AI resource appears.

## Exam traps

- "Which service limits per-user token consumption?" -> **AI Gateway (APIM policy)**, not Foundry guardrails.
- "Which service detects prompt injection at runtime?" -> **Defender for AI Service**, surfaced through the Data and AI security dashboard.
- Do not answer "APIM key auth" for outbound calls to Foundry - use **managed identity**.

## Cleanup

- Delete the APIM API and back-end.
- Optionally remove the APIM instance if created just for this lab.
- Leave Defender for AI Service enabled if you plan to run Lab 04.

## References

- <https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities>
- <https://learn.microsoft.com/en-us/azure/api-management/azure-openai-api-from-specification>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-security>
- <https://learn.microsoft.com/en-us/azure/ai-services/content-safety/overview>
