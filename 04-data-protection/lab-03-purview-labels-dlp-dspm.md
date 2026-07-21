# Lab 03: Purview Labels, DLP, and DSPM for AI

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** $0 incremental lab cost, but requires Microsoft Purview and Microsoft 365 licensing  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create a sensitivity label, publish it, test protection in SharePoint
or Exchange, create a DLP policy, and review how Purview DSPM for AI surfaces
data exposure for Copilot and AI scenarios.

**Why this matters for SC-500:**
- This is one of the biggest differences between SC-500 and AZ-500
- You must know how **labels**, **DLP**, and **DSPM for AI** work together
- Many exam questions are really asking: **classify, prevent, or discover?**

**Control model:**

```text
Sensitivity label -> classifies/protects content
DLP policy        -> blocks or warns on movement/sharing
DSPM for AI       -> discovers risky AI data exposure and prompt patterns
```

---

## Prerequisites

- Microsoft 365 tenant with Purview portal access
- Compliance Administrator or higher permissions
- Test SharePoint site or Teams/Exchange data source
- Optional: Microsoft 365 Copilot activity for DSPM for AI insights

---

## Part 1: Create a sensitivity label

### Step 1.1 - Create the label

1. Open **Microsoft Purview portal**
2. Go to **Information Protection** -> **Labels**
3. Create a new label:
   - **Name:** `Confidential - SC500 Lab`
   - **Tooltip:** `Use for internal sensitive data`

### Step 1.2 - Configure protection

Choose one or more protections:
- Encryption for internal users only
- Content marking such as header/footer
- Access restrictions for external users

### Step 1.3 - Publish the label

1. Create a **label policy**
2. Publish to your test users or a pilot group
3. Wait for policy propagation

---

## Part 2: Apply the label and test access

### Step 2.1 - Create a test file

Create a document with:
- Employee IDs
- Test payment card data
- HR salary or identity-like fields

### Step 2.2 - Apply the label

1. Upload the file to SharePoint or OneDrive
2. Apply `Confidential - SC500 Lab`

### Step 2.3 - Test the effect

1. Sign in as an authorized user and confirm access works
2. Sign in as a user outside the allowed audience and confirm access is blocked

> Labels answer: **How do I classify and protect the content itself?**

---

## Part 3: Create a DLP policy

### Step 3.1 - Create the policy

1. In Purview, open **Data loss prevention** -> **Policies**
2. Create a new policy using:
   - **Custom** or a built-in template such as financial or privacy data
3. Scope it to:
   - SharePoint
   - OneDrive
   - Exchange
   - Teams (optional)

### Step 3.2 - Configure a rule

Create a rule such as:
- If content contains a credit card number or sensitive label
- Then block external sharing
- Show policy tip to the user
- Send alert to admins

### Step 3.3 - Test the policy

1. Try sharing the sensitive file externally
2. Confirm the DLP policy blocks or warns as configured

> DLP answers: **How do I stop risky movement or sharing of sensitive data?**

---

## Part 4: Review DSPM for AI

### Step 4.1 - Open DSPM for AI

1. In Purview, open **Data Security Posture Management for AI**
2. Review:
   - Overshared content
   - Sensitive data exposure to Copilot
   - Risky prompts or AI interactions

### Step 4.2 - Compare the finding to your label/DLP state

Ask:
- Did the label reduce who could access the content?
- Did DLP block risky sharing?
- Did DSPM for AI still reveal exposure patterns or recommendations?

### Step 4.3 - Record the difference

Write a short note:
- **Label** = protects content
- **DLP** = prevents movement/sharing
- **DSPM for AI** = discovers risky exposure and AI-related posture gaps

---

## Part 5: Connect the controls to exam scenarios

Use these quick prompts:

1. `A file is overshared to Copilot users. Which control identifies the problem?`
2. `A user should be blocked from emailing sensitive data externally. Which control prevents it?`
3. `A file should only open for an approved audience even if downloaded. Which control protects it?`

Expected answers:
1. **DSPM for AI**
2. **DLP**
3. **Sensitivity label with protection**

---

## Validation Steps

Confirm all of the following:

- A sensitivity label exists and is published
- A protected test file is labeled
- A DLP policy blocks or warns on risky sharing
- DSPM for AI shows recommendations or posture insights relevant to Copilot/AI

---

## Exam traps

- **DSPM for AI** discovers and prioritizes exposure; it is not the same as DLP
- **DLP** is a prevention/control plane, not a discovery dashboard
- **Sensitivity labels** travel with content and protect the content itself
- If the question says **overshared data to Copilot**, think **Purview DSPM for AI**

---

## Cleanup Instructions

1. Remove the test label/policy if you do not want it left in the tenant
2. Delete the sample sensitive documents
3. Remove pilot assignments if they were only for the lab

---

## References

- <https://learn.microsoft.com/en-us/purview/sensitivity-labels>
- <https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp>
- <https://learn.microsoft.com/en-us/purview/ai-microsoft-purview>
