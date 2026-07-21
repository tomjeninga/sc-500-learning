# Lab 05: Intro to App Platform Security

## SC-500 Skill Mapping

This lab maps to SC-500 secure compute objectives around:

- Implementing security controls for Azure App Service
- Implementing security controls for Azure Functions
- Implementing security controls for Container Apps
- Recognizing when API Management becomes the next protection layer for back-end APIs

---

## Learning Objectives

After completing this lab, you will be able to:

- Identify the baseline security controls common to Azure application platform services
- Apply authentication, ingress restriction, and secretless access patterns to App Service and Functions
- Choose the correct ingress and identity posture for Container Apps
- Distinguish service-native protection from deeper API gateway enforcement

---

## Prerequisites

- Contributor on `rg-sc500-lab`
- Optional `01-identity-governance/lab-04-workload-identities.md` if you want to reuse managed identity and Key Vault patterns
- A test Entra user or group for authentication validation

---

## Architecture (in words)

This intro lab focuses on the baseline controls that live on the application service itself. Clients reach App Service, Functions, or Container Apps directly or through a later gateway layer. The first decision is whether the workload is properly authenticated, minimally exposed, and free of embedded secrets.

```text
User or caller
    |
    +--> App Service
    +--> Function App
    \--> Container App

Baseline controls on each service:
- identity and authentication
- ingress and network exposure
- managed identity and secret handling
```

---

> **Depends on:** `01-identity-governance/lab-04-workload-identities.md` if you want to reuse managed identity and Key Vault patterns
> **Reused by:** `02-platform-protection/lab-06-aks-acr-defender-containers.md` and `02-platform-protection/lab-07-logic-apps-and-apim-security.md`
> **Delete after:** you finish the platform-service validation that depends on the apps or temporary ingress settings

## Part 1: Lock in the baseline control model

Before building anything, use this mental map:

| Control | What question it answers |
| --- | --- |
| Authentication | Who is allowed to call the app? |
| Network exposure | Who can even reach the endpoint? |
| Managed identity | How does the app reach Azure resources without secrets? |
| Gateway layer | Do you need separate API-edge enforcement? |

**Why this control, not the distractor:**

- App authentication does not automatically mean the app is network-isolated
- Private or restricted ingress does not replace user or workload authentication
- Managed identity is usually stronger than storing connection secrets in configuration
- API Management is a follow-up enforcement layer, not the first baseline control to learn here

---

## Part 2: Secure an App Service web app

### Step 2.1 - Create or reuse an App Service

1. Create a basic Web App in `rg-sc500-lab`, or reuse an existing one
2. Turn on:
   - **HTTPS Only**
   - **Minimum TLS 1.2**

### Step 2.2 - Enable built-in authentication

1. Open the Web App -> **Authentication**
2. Add **Microsoft Entra ID** as the identity provider
3. Configure the app to require authentication
4. Test sign-in with an allowed user

### Step 2.3 - Reduce network exposure

1. Open **Networking** -> **Access restrictions**
2. Allow only:
   - Your current IP for testing, or
   - Another explicitly trusted source
3. Add a deny-all rule below the allow rules

> App Service security starts with the combination of identity, TLS, and intentional ingress.

---

## Part 3: Secure a Function App

### Step 3.1 - Create or reuse a Function App

1. Create a basic HTTP-trigger Function App or reuse an existing one
2. Turn on:
   - **HTTPS Only**
   - **Authentication**

### Step 3.2 - Review trigger exposure

1. In **Authentication**, require sign-in with Microsoft Entra ID if the function should not be public
2. In **Networking**, review access restrictions or private endpoint options based on your hosting plan
3. If the function is publicly reachable, restrict callers to only the approved path

### Step 3.3 - Review secret handling

1. Review **Application settings**
2. Prefer:
   - **Managed identity**
   - **Key Vault references**
3. Avoid embedded secrets when a managed option exists

> Functions questions usually test whether you can secure both the function trigger and the app configuration.

---

## Part 4: Secure a Container App

### Step 4.1 - Create or reuse a Container App

1. Deploy a simple Container App in a Container Apps environment
2. Choose one of these ingress patterns:
   - **Internal ingress only** for back-end workloads
   - **External ingress** only when there is a clear caller requirement

### Step 4.2 - Review the baseline controls

Inspect:

- Ingress exposure
- Secrets
- Managed identity support
- Revision and environment boundaries

### Step 4.3 - Reduce unnecessary exposure

For the lab, set the app so it is not broadly internet-exposed unless you explicitly need that for testing.

> For SC-500, the exam decision is usually about minimizing exposure and preferring managed identity over secrets.

---

## Part 5: Know when to step into the next lab

Use this quick map to decide whether the baseline is enough or whether you need the next protection layer.

| If the question is about... | Start with... | Then go deeper in... |
| --- | --- | --- |
| App sign-in, TLS, and direct endpoint exposure | This lab | — |
| Function trigger exposure and configuration secrets | This lab | — |
| Container ingress and identity | This lab | `lab-06-aks-acr-defender-containers.md` for container platform depth |
| JWT validation, throttling, and API-edge policy enforcement | This lab for baseline backend hardening | `lab-07-logic-apps-and-apim-security.md` |

---

## Validate

Confirm all of the following:

- App Service requires authentication
- Function App requires authentication and is not openly exposed without need
- Container App ingress is intentionally chosen and not left overly broad
- You can explain why API Management is a follow-up enforcement layer rather than the main hands-on focus of this intro lab

---

## Exam Traps

- **App Service Authentication** is not the same as **network restriction**
- **Functions** need both trigger awareness and secure app configuration
- **Container Apps** should not default to broad external ingress without a reason
- **Managed identity** is usually preferred over app settings with secrets
- **API Management** is important, but deep token and throttling enforcement belong in the follow-up lab, not this baseline lab

---

## Cleanup

1. Delete test platform services if you created them only for the lab
2. Remove temporary IP allow rules
3. Leave any reusable app resources only if you plan to continue to the follow-up labs

---

## References

- <https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization>
- <https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts>
- <https://learn.microsoft.com/en-us/azure/container-apps/security>
