# Lab 03 - Secure Microsoft Entra Agent ID

## SC-500 skill mapping

- Implement Conditional Access for Microsoft Entra Agent ID
- Analyze blast radius for security risks related to Entra Agent ID by using Defender XDR
- Manage Entra Agent ID access
- Enable and configure real-time protection for Microsoft Copilot Studio agents (related)

## Learning objectives

- Register or identify a Microsoft Entra Agent ID for an AI agent.
- Apply a Conditional Access policy that targets the agent identity.
- Review the agent's assigned permissions and connectors.
- Use Defender XDR to analyze the blast radius of a compromised agent.

> **Depends on:** a Microsoft 365 or Entra tenant with an agent identity, Microsoft Copilot Studio or equivalent agent surface, and Defender XDR access
> **Reused by:** no required follow-up lab; this lab is best treated as a focused Agent ID exercise
> **Delete after:** you finish Conditional Access and blast-radius validation and decide whether the test agent should remain

## Prerequisites

- Microsoft 365 / Entra ID tenant with **Entra ID P2** or equivalent (for Conditional Access + risk).
- **Microsoft Defender XDR** access.
- At least one **Microsoft Copilot Studio** agent or an app-registration-backed agent identity.
- Conditional Access Administrator and Security Reader roles.

## Steps

1. In the **Microsoft Entra admin center**, open **Agent ID** (or Enterprise applications for the agent).
2. Confirm the agent has an Agent ID and review its **API permissions**, **owners**, and **assigned users/groups**.
3. Create a **Conditional Access** policy:
   - Target: the specific Entra Agent ID (or a group containing agent identities).
   - Conditions: locations, client apps, device compliance.
   - Grant: require compliant device or require managed device.
   - Start in **Report-only mode**, then enable.
4. In **Microsoft Copilot Studio**, enable **real-time protection** for the agent if the option is available in your tenant.
5. In **Defender XDR**, open the **Agents / Identity** view and select the agent.
6. Run **blast radius analysis** to see which data sources, users, and resources the agent could reach if compromised.
7. Reduce blast radius by removing unused connectors or scoping permissions to a minimal set.

## Validate

- Conditional Access sign-in logs show policy evaluations for the agent principal.
- Blast radius view in Defender XDR shrinks after removing an unused connector.
- Real-time protection alerts appear when a suspicious prompt or action is tested.

## Exam traps

- "How do you restrict an agent to run only from a compliant device?" -> **Conditional Access targeting Entra Agent ID**, not by rotating a client secret.
- "What tool shows what a compromised agent could reach?" -> **Defender XDR blast radius**, not Defender for Cloud.
- Do not answer "assign an RBAC role" for controlling agent authentication conditions - that is Conditional Access.

## Cleanup

- Set the Conditional Access policy to Report-only or Off if not needed.
- Restore any removed connectors that your production agent still needs.

## References

- <https://learn.microsoft.com/en-us/entra/identity/agentid/overview>
- <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview>
- <https://learn.microsoft.com/en-us/defender-xdr/microsoft-365-defender>
- <https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance>
