# Lab 04 - Enable Defender for AI Service and the Data and AI security dashboard

## SC-500 skill mapping

- Enable Defender for AI Service in Cloud Workload Protection in Defender for Cloud
- Monitor AI security by using the Data and AI security dashboard in Defender for Cloud
- Configure guardrails for agent security in Foundry (related)

## Learning objectives

- Enable Defender for AI Service on your subscription.
- Generate a benign alert against a Foundry model.
- Explore the Data and AI security dashboard in Defender for Cloud.
- Understand where AI signals come from (Foundry, APIM, Purview, Defender XDR).

## Prerequisites

- Same lab subscription used in Lab 01 (AI Gateway).
- Microsoft Foundry project with at least one model deployment.
- Defender for Cloud enabled on the subscription.
- Diagnostic settings enabled on the Foundry resource sending to Log Analytics.

## Steps

1. In **Defender for Cloud** -> **Environment settings** -> select the subscription.
2. Enable **Defender for AI Service** under workload protection plans.
3. Confirm the Foundry resource is covered and diagnostic settings are collecting data.
4. In **Microsoft Foundry**, review **guardrail settings** for the target model and add content filters if missing.
5. Generate test traffic:
   - Send a benign prompt.
   - Send a jailbreak-style prompt.
   - Send a prompt trying to extract system prompts.
6. Wait a few minutes for alerts to appear.
7. In Defender for Cloud, open **Data and AI security dashboard** and review:
   - AI resources inventory
   - Recent alerts (prompt injection, data exposure, misuse)
   - Recommendations for AI resources

## Validate

- Defender for AI Service shows as enabled for the subscription.
- The Data and AI security dashboard lists your Foundry project.
- At least one **prompt injection** or **jailbreak** alert appears in Defender for Cloud.
- Foundry content filter blocks the disallowed prompt at the model layer, and APIM policy logs the request at the gateway layer.

## Exam traps

- "Which single dashboard aggregates AI posture and alerts?" -> **Data and AI security dashboard in Defender for Cloud**.
- Foundry guardrails and Defender for AI Service are **complementary**, not replacements for each other.
- "How do I get alerts for prompt injection on my Foundry model?" -> **Defender for AI Service**, not Sentinel by itself (though you can forward alerts to Sentinel).

## Cleanup

- If cost is a concern, disable Defender for AI Service after the lab.
- Delete test prompts from Foundry logs if they contain sensitive test data.

## References

- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-security>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/data-aware-security-dashboard-overview>
- <https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/content-filtering>
- <https://learn.microsoft.com/en-us/azure/ai-foundry/>
