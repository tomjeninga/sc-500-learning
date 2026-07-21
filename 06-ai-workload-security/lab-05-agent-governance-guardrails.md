# Lab 05: Agent Governance with Copilot Studio, Foundry Guardrails, and Microsoft 365 Admin Center

## SC-500 Skill Mapping

This lab maps to SC-500 AI security objectives around:

- Enabling real-time protection for Microsoft Copilot Studio agents
- Configuring guardrails for agent security in Foundry
- Managing agents in the Microsoft 365 admin center

---

## Learning Objectives

After completing this lab, you will be able to:

- Review Microsoft Copilot Studio agent runtime security and governance controls
- Govern what agents or actions are available through Microsoft 365 administrative controls
- Configure Foundry content filters and guardrails that shape model or agent behavior
- Distinguish governance controls from runtime detection and identity controls

---

## Prerequisites

- Microsoft 365 tenant with Microsoft Copilot Studio access
- Access to Microsoft 365 admin center and Power Platform admin center
- A Foundry project with a model deployment
- Recommended: `lab-01-ai-gateway.md` and `lab-03-entra-agent-id.md`

---

## Architecture (in words)

AI agent governance spans multiple control planes. Copilot Studio governs the agent surface and its runtime status. Microsoft 365 admin center governs which agents or AI actions are available to users. Foundry guardrails shape prompt and completion behavior. Defender for Cloud and Defender XDR then observe and detect risk, but they do not replace those preventive controls.

```text
Maker / admin
    |
    +--> Copilot Studio governance
    |      +--> runtime protection status
    |      +--> data policies and connector limits
    |
    +--> Microsoft 365 admin center
    |      \--> which agents and AI actions are exposed to users
    |
    \--> Microsoft Foundry
           \--> content filters, prompt shields, and other guardrails
```

---

> **Depends on:** `06-ai-workload-security/lab-01-ai-gateway.md` for a Foundry deployment and `06-ai-workload-security/lab-03-entra-agent-id.md` for the agent identity side of governance
> **Reused by:** no required follow-up lab; this is the governance capstone for the AI workload sequence
> **Delete after:** you finish validating guardrails and admin controls and no longer need the test agent or deployment settings

## Part 1: Lock in the AI governance model

Use this mental map before touching the portals:

| Control plane | What it answers |
| --- | --- |
| Copilot Studio governance | Is the agent itself safely configured and governed? |
| Microsoft 365 admin center | Which agents or AI actions can users access? |
| Foundry guardrails | What prompts and outputs should be blocked, annotated, or shaped? |
| Defender for Cloud / Defender XDR | What threats or risky blast radius are observed after deployment? |

**Why this control, not the distractor:**

- Foundry guardrails shape model behavior; they do not manage Microsoft 365 agent availability
- Defender for AI Service detects runtime threats; it does not replace preventive guardrails
- Entra Agent ID governs identity and Conditional Access, but not content filtering behavior

---

## Part 2: Review Copilot Studio runtime protection and governance

### Step 2.1 - Open the agent security view

1. Open **Microsoft Copilot Studio**
2. Go to the target agent
3. Review the visible security or runtime protection status on the agent page

### Step 2.2 - Review maker and connector governance

Inspect the relevant governance surfaces or linked admin controls for:

- Allowed connectors and actions
- HTTP request capability
- Trigger usage
- Knowledge sources
- Publication options

### Step 2.3 - Review data policy posture

If your tenant uses Power Platform data policies, confirm whether the agent is constrained by those policies and record one example of how they reduce exfiltration or unsafe connector use.

> Copilot Studio governance is often about reducing what the agent is allowed to do before it is widely exposed.

---

## Part 3: Review agent governance in Microsoft 365 admin center

### Step 3.1 - Open the admin control surface

1. Open the **Microsoft 365 admin center**
2. Navigate to the area that governs conversational or AI actions and agents available in Microsoft 365 Copilot

### Step 3.2 - Record the governance decision

Review and document:

- Which agents are available to users
- Whether any agent or action should be disabled
- Whether a test agent should remain visible after the lab

### Step 3.3 - Compare tenant governance vs maker governance

Write down the difference:

- **Maker-side governance** controls how the agent is built
- **Admin-side governance** controls what users can access or invoke

---

## Part 4: Configure Foundry guardrails

### Step 4.1 - Open the content filter controls

1. Open the Foundry project that hosts your model deployment
2. Go to the **Guardrails + controls** or equivalent content-filter area
3. Create or review a content filter configuration

### Step 4.2 - Review the main filter types

Look for the controls that matter most for SC-500:

- Harm categories such as hate, sexual, violence, and self-harm
- **Prompt shields** for user prompt attacks or indirect attacks
- Optional filters such as:
  - Protected material
  - PII
  - Groundedness

### Step 4.3 - Apply the filter to a deployment

1. Associate the content filter with the target deployment
2. Test:
   - A benign prompt
   - A jailbreak-style prompt
   - A prompt that should hit an output filter if configured

Record the behavior:

- blocked prompt with HTTP 400 or equivalent
- completion marked with `finish_reason = content_filter`
- annotated-only behavior if your configuration uses annotations without blocking

---

## Part 5: Compare guardrails to the other AI controls

Use this table to lock in the boundaries:

| If the question is about... | Best control |
| --- | --- |
| Per-user token limits or AI gateway throttling | APIM AI Gateway |
| Blocking harmful prompts or filtered completions | Foundry content filters / guardrails |
| Runtime prompt injection detections and central alerting | Defender for AI Service |
| Agent sign-in conditions or device requirements | Entra Agent ID + Conditional Access |
| Which agents users can access in Microsoft 365 | Microsoft 365 admin center governance |

---

## Validate

Confirm all of the following:

- You reviewed Copilot Studio runtime protection or security status for a test agent
- You identified at least one governance control that limits agent capabilities or exposure
- You reviewed agent availability or AI action governance in Microsoft 365 admin center
- A Foundry content filter or guardrail is attached to the deployment
- You can explain the difference between guardrails, gateway policies, identity controls, and Defender detections

---

## Exam Traps

- **Foundry guardrails** are not the same as **AI Gateway** policies
- **Defender for AI Service** detects threats; it does not replace preventive content filters
- **Microsoft 365 admin center** governs which agents or actions are available to users; it is not the same as Foundry model configuration
- **Copilot Studio** governance is not only about prompts; connectors, triggers, and publication controls also matter

---

## Cleanup

1. Remove or revert any temporary content filter configurations that were created only for testing
2. Restore any agent visibility or governance changes if they were temporary for the lab
3. Delete the test agent if it is no longer needed

---

## References

- <https://learn.microsoft.com/en-us/microsoft-copilot-studio/security-and-governance>
- <https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/content-filtering>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/data-aware-security-dashboard-overview>
