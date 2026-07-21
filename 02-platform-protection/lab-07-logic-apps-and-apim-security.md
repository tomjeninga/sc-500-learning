# Lab 07: Logic Apps and API Management Security

## SC-500 Skill Mapping

This lab maps to SC-500 secure compute objectives around:

- Implementing security controls for Azure Logic Apps
- Implementing security controls for Azure App Service and Azure Functions at the API edge
- Implementing back-end API protection with Azure API Management policies
- Using managed identity and least privilege for workflow and API integration

---

## Learning Objectives

After completing this lab, you will be able to:

- Secure a Logic App workflow with managed identity and reduced trigger exposure
- Protect App Service or Function App APIs with built-in authentication and network restrictions
- Apply Azure API Management policies such as token validation and throttling
- Explain why APIM is a protection boundary instead of just a publishing layer
- Validate a secure back-end pattern where APIM fronts the app and the app is not broadly exposed

---

## Prerequisites

- Azure subscription with Contributor permissions
- Optional existing App Service or Function App from `lab-05-app-platform-security.md`
- Optional existing API Management instance from `06-ai-workload-security/lab-01-ai-gateway.md`
- A test Microsoft Entra user, app registration, or group for authentication validation

---

## Architecture (in words)

Azure API Management sits in front of a back-end App Service or Function App and enforces authentication and throttling before traffic reaches the API. A Logic App uses managed identity to call or update resources without stored secrets.

```text
Client or caller
      |
      v
Azure API Management
      |
      +--> validate-jwt / throttling / policy enforcement
      v
App Service or Function App backend

Logic App workflow
      |
      v
Managed identity-based calls to Azure resources or APIs
```

---

> **Depends on:** `02-platform-protection/lab-05-app-platform-security.md` for the core App Service and Function App baseline
> **Reused by:** `03-security-operations/lab-05-sentinel-automation-playbooks.md` and `03-security-operations/lab-06-logic-apps-security-for-playbooks.md` conceptually, because both rely on Logic Apps security patterns
> **Delete after:** you finish testing workflow identity and API policy enforcement

## Part 1: Lock in the control boundaries

Before configuring anything, separate the control planes:

| Service | Main security purpose |
| --- | --- |
| App Service / Functions | App authentication, platform identity, and backend access control |
| Logic Apps | Workflow automation with secure connector and identity choices |
| API Management | API gateway enforcement for auth, throttling, and backend policy |

**Why this control, not the distractor:**
- **App Service Authentication** is not the same as APIM token enforcement
- **Logic Apps** can automate workflows, but they should not carry broad static secrets if managed identity works
- **APIM** should validate and shape requests before they hit the backend API

---

## Part 2: Secure the backend app or function

### Step 2.1 - Review built-in authentication

1. Open the App Service or Function App backend
2. Go to **Authentication**
3. Configure **Microsoft Entra ID** as the provider
4. Set unauthenticated requests to require sign-in or return `401` if the workload is API-first

### Step 2.2 - Review access restrictions

1. Open **Networking** -> **Access restrictions**
2. Limit direct access to:
   - APIM, trusted ingress, or
   - Your temporary test IP only for validation
3. Add a deny-all rule after the trusted sources

### Step 2.3 - Review app configuration security

1. Inspect app settings
2. Prefer:
   - Managed identity
   - Key Vault references
3. Avoid embedded secrets when platform identity is available

---

## Part 3: Secure the Logic App workflow

### Step 3.1 - Create or reuse a Logic App

1. Create or open a Logic App workflow
2. Review the trigger type and whether the trigger endpoint is intentionally exposed

### Step 3.2 - Enable managed identity

1. Open **Identity**
2. Enable **system-assigned managed identity**
3. Grant only the role the workflow needs on target resources

### Step 3.3 - Reduce trigger and run-history risk

Review:

- Whether the trigger URL is broader than necessary
- Whether secrets or sensitive values appear in workflow actions
- Whether access to run history should be limited to only the admins or analysts who need it

> Logic Apps security is often about controlling both the workflow identity and the workflow entry point.

---

## Part 4: Apply API Management protections

### Step 4.1 - Put APIM in front of the backend

1. Open your API Management instance
2. Import or configure a backend API that targets the App Service or Function App

### Step 4.2 - Validate caller identity

Apply an inbound token validation policy:

- `validate-jwt`, or
- `validate-azure-ad-token` if you are using Microsoft Entra-based protection

### Step 4.3 - Apply throttling

Add one of the rate controls:

- `rate-limit`
- `rate-limit-by-key`

Use the key-based option when you need per-caller or per-subscription throttling and the APIM tier supports it.

### Step 4.4 - Protect the backend trust path

Where possible:

- Restrict the backend so APIM is the intended caller
- Prefer **managed identity** for APIM outbound access to Azure backends

---

## Part 5: Validate the layered pattern

### Step 5.1 - Test backend direct access

Verify the backend is not casually reachable without the intended auth or source restrictions.

### Step 5.2 - Test APIM path

Verify:

- Token validation succeeds for valid callers
- Invalid or missing tokens are blocked
- Throttling applies as expected when limits are exceeded

### Step 5.3 - Test Logic App identity

Verify the Logic App can perform its intended action by using managed identity and without stored credentials.

---

## Validate

Confirm all of the following:

- App Service or Function App authentication is enabled
- Direct backend access is reduced with access restrictions or equivalent controls
- Logic App uses managed identity for resource access
- APIM validates tokens before forwarding requests
- APIM applies at least one throttling or abuse-control policy

---

## Exam Traps

- **Easy Auth** on App Service or Functions simplifies authentication but does not replace network restriction or gateway policy
- **APIM** is not just documentation or developer onboarding; it is a security enforcement point
- **Managed identity** is usually preferable to storing connector or backend secrets in a Logic App
- **Rate-limit-by-key** is not supported in every APIM tier, so plan selection can matter

---

## Cleanup

1. Delete the Logic App if it was created only for the lab
2. Remove temporary test IP allow rules
3. Remove test APIs or policies from APIM if they were added only for the lab

---

## References

- <https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization>
- <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-securing-a-logic-app>
- <https://learn.microsoft.com/en-us/azure/api-management/validate-jwt-policy>
- <https://learn.microsoft.com/en-us/azure/api-management/rate-limit-by-key-policy>
