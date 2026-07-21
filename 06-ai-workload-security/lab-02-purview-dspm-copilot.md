# Lab 02 - Microsoft Purview DSPM for AI: discover Copilot risks

## SC-500 skill mapping

- Identify overexposure of data in SharePoint
- Identify risks related to Microsoft Copilot and AI apps by using Microsoft Purview Data Security Posture Management (DSPM)
- Manage agents in Microsoft 365 admin center (related)

## Learning objectives

- Enable Microsoft Purview DSPM for AI.
- Detect sensitive data over-exposure to Microsoft 365 Copilot through SharePoint sharing.
- Take a remediation action: restrict oversharing or apply a sensitivity label.
- Understand how DSPM complements DLP and sensitivity labels.

## Prerequisites

- Microsoft 365 tenant with **Microsoft Purview** and **Microsoft 365 Copilot** licenses.
- Global Reader plus Compliance Administrator (or higher) permissions.
- At least one SharePoint site with a test file that contains sensitive info (test credit card number, employee ID format).
- Some Copilot activity in the tenant (at least a few prompts by test users).

## Architecture (in words)

Users chat with Microsoft 365 Copilot. Copilot reads from SharePoint, OneDrive, Teams, and Exchange. Purview DSPM for AI inspects those interactions, classifies data, and surfaces overexposure and risky prompts in the Purview portal.

## Steps

1. In the **Microsoft Purview portal**, open **Data Security Posture Management for AI**.
1. **Turn on** the analytics and consent to data collection as prompted.
1. Wait for the initial scan (usually 24-48 hours in a real tenant).
1. Open **Recommendations** and review overshared content, risky prompts, and sensitive data exposure.
1. Pick one **SharePoint oversharing** finding and drill into the file and permissions.
1. Apply a remediation:
   - Remove "Everyone except external users" from the file, or
   - Apply a **sensitivity label** (for example, Confidential) that restricts access.
1. Confirm the DSPM insight moves to "Mitigated" after the next scan cycle.
1. In **Microsoft 365 admin center**, review the agents blade and confirm which agents can be installed.

## Validate

- The Purview DSPM dashboard shows AI interaction volume, top data types, and unethical/risky prompts.
- The remediated file no longer appears as overshared to Copilot.
- Sensitivity label enforcement blocks unauthorized viewers from receiving Copilot answers based on that file.

## Exam traps

- "Which product identifies data overexposure to Microsoft Copilot?" -> **Microsoft Purview DSPM for AI**.
- "How do you prevent Copilot from surfacing HR salary data to non-HR users?" -> combine **sensitivity labels** + **SharePoint access controls** informed by DSPM, not DLP alone.
- DSPM discovers exposure; **DLP** blocks movement. They are complementary, not interchangeable.

## Cleanup

- Revert test permissions and remove test sensitive files if you do not want them retained.
- Turn off DSPM analytics only if your tenant policy requires it - otherwise leave it on.

## References

- <https://learn.microsoft.com/en-us/purview/ai-microsoft-purview>
- <https://learn.microsoft.com/en-us/purview/ai-microsoft-purview-considerations>
- <https://learn.microsoft.com/en-us/microsoft-365-copilot/microsoft-365-copilot-overview>
