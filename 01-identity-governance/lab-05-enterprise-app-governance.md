# Lab 05: Enterprise Applications, App Registrations, and Consent Governance

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** $0  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will create an app registration, inspect the matching enterprise
application, add Microsoft Graph permissions, configure user consent settings,
enable the admin consent workflow, and review or revoke OAuth permission grants.

**Why this matters for SC-500:**
- SC-500 tests the difference between **app registrations** and **enterprise applications**
- Consent governance is a high-value identity topic that many Azure-only prep paths miss
- The exam often asks which control prevents risky third-party apps from gaining excessive access

**Architecture:**

```text
App registration
  -> creates service principal / enterprise application in tenant
  -> requests OAuth permissions to Microsoft Graph
  -> governed by user consent settings + admin consent workflow
  -> optionally restricted by assignment requirements
```

---

## Prerequisites

- Global Administrator, Cloud Application Administrator, or Application Administrator
- Microsoft Entra ID P1 or P2 recommended
- At least one non-admin test user

---

## Part 1: Create an app registration

### Step 1.1 - Register the application

1. Open **Microsoft Entra admin center**
2. Go to **Applications** -> **App registrations**
3. Click **+ New registration**
4. Configure:
   - **Name:** `sc500-demo-graph-client`
   - **Supported account types:** Accounts in this organizational directory only
   - **Redirect URI:** Web -> `https://jwt.ms`
5. Click **Register**

### Step 1.2 - Capture the app identity

6. Note the:
   - **Application (client) ID**
   - **Directory (tenant) ID**
   - **Object ID**

> The app registration is the application definition. The actual tenant-side
> instance users sign in to is the **enterprise application** (service principal).

---

## Part 2: Review the matching enterprise application

### Step 2.1 - Open the enterprise application

1. Go to **Applications** -> **Enterprise applications**
2. Search for `sc500-demo-graph-client`
3. Open it and review:
   - **Properties**
   - **Users and groups**
   - **Permissions**
   - **Sign-in logs**

### Step 2.2 - Require assignment

1. In **Properties**, set **Assignment required?** to **Yes**
2. Save
3. In **Users and groups**, assign only a test user or lab group

> This is a classic governance control: users cannot access the app unless they
> are explicitly assigned.

---

## Part 3: Add Microsoft Graph permissions

### Step 3.1 - Add delegated permissions

1. Return to the **App registration**
2. Open **API permissions**
3. Click **+ Add a permission** -> **Microsoft Graph**
4. Add:
   - **Delegated** -> `User.Read`
   - **Delegated** -> `Group.Read.All`

### Step 3.2 - Compare permission types

Review the difference:
- **Delegated permission** = app acts on behalf of a signed-in user
- **Application permission** = app acts as itself, without a user

> For the exam, if the question says the app runs as a background daemon with no
> signed-in user, think **application permission**.

---

## Part 4: Configure consent governance

### Step 4.1 - Review user consent settings

1. In **Enterprise applications**, open **Consent and permissions**
2. Open **User consent settings**
3. Review the options:
   - Allow user consent for apps
   - Allow user consent only for verified publishers and selected low-risk permissions
   - Do not allow user consent

### Step 4.2 - Enable the admin consent workflow

1. In **Consent and permissions**, open **Admin consent settings**
2. Turn on the **admin consent workflow**
3. Add one or more reviewers
4. Configure request expiration and notifications
5. Save

> This workflow is the governance answer when users need admin-approved app access
> without giving broad standing consent rights.

---

## Part 5: Grant and review consent

### Step 5.1 - Grant admin consent

1. Return to the app registration
2. Open **API permissions**
3. Click **Grant admin consent for <tenant>**
4. Confirm that the permission status becomes granted

### Step 5.2 - Review OAuth grants in the enterprise app

1. Open the matching **Enterprise application**
2. Go to **Permissions**
3. Review which permissions are granted and by whom

### Step 5.3 - Revoke a grant

If you want to practice cleanup:

1. Remove a granted permission
2. Re-add it and re-run admin consent

> This teaches the difference between **configuring app permissions** and
> **granting tenant consent**.

---

## Part 6: Optional sign-in and token check

Use the app registration with `https://jwt.ms` to inspect the token and verify
the app is requesting the expected scopes.

1. Use the **Authentication** blade to verify redirect URI
2. Sign in through the app if you have a simple test harness or auth URL
3. Inspect the resulting token claims in `jwt.ms`

---

## Validation Steps

Confirm all of the following:

- The app registration exists
- The matching enterprise application exists
- Assignment required is turned on
- A Graph permission requiring admin consent is present
- Admin consent workflow is enabled
- You can identify and review granted OAuth permissions

---

## Exam traps

- **App registration** is not the same as **enterprise application**
- **Delegated** permissions use the signed-in user's rights; **application** permissions do not
- **Grant admin consent** is different from just adding a permission to the app
- **Assignment required** controls who can use the enterprise app
- **User consent settings** and **admin consent workflow** are the right answers for risky third-party app governance

---

## Cleanup Instructions

1. Remove the test app registration and enterprise application if not needed
2. Revert user consent settings if you changed them only for the lab
3. Remove temporary assignments to test users/groups

---

## References

- <https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-enterprise-app-management>
- <https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app>
- <https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-user-consent>
- <https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-admin-consent-workflow>
