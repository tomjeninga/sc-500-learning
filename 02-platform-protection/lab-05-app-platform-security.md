# Lab 05: App Platform Security with App Service, Functions, Container Apps, and API Management

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$2-6 depending on the services you create for the lab  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will apply core security controls across Azure application platform services:
App Service, Azure Functions, Azure Container Apps, and API Management.

**Why this matters for SC-500:**
- The official study guide explicitly includes application platform services
- Candidates often know infrastructure security but overlook service-native controls
- The exam loves scenarios that ask where to apply authentication, network controls,
  secrets handling, and API protection

**Architecture:**

```text
User / client
    |
    v
API Management
    |
    +--> App Service (auth + access restrictions)
    +--> Function App (auth + network restrictions)
    \--> Container App (controlled ingress)
```

---

## Prerequisites

- Contributor on `rg-sc500-lab`
- Optional existing API Management instance from the AI workload lab
- A test Entra ID group or user for app authentication

---

## Part 1: Secure an App Service web app

### Step 1.1 - Create or reuse an App Service

1. Create a basic Web App in `rg-sc500-lab`, or reuse an existing one
2. Turn on:
   - **HTTPS Only**
   - **Minimum TLS 1.2**

### Step 1.2 - Enable built-in authentication

1. Open the Web App -> **Authentication**
2. Add **Microsoft Entra ID** as the identity provider
3. Configure the app to require authentication
4. Test sign-in with an allowed user

### Step 1.3 - Add access restrictions

1. Open **Networking** -> **Access restrictions**
2. Allow only:
   - Your current IP for testing, or
   - The APIM subnet / trusted ingress source
3. Add a deny-all rule below the allow rules

> App Service security is often about combining **identity** and **network** controls.

---

## Part 2: Secure a Function App

### Step 2.1 - Create or reuse a Function App

1. Create a basic HTTP-trigger Function App or reuse an existing one
2. Turn on:
   - **HTTPS Only**
   - **Authentication**

### Step 2.2 - Lock down access

1. In **Authentication**, require sign-in with Microsoft Entra ID
2. In **Networking**, review access restrictions or private endpoint options based on your plan
3. If the app is publicly reachable, add restrictions so only approved callers can reach it

### Step 2.3 - Review secret handling

1. Review **Application settings**
2. Prefer references to **Key Vault** or managed identity over embedded secrets

> Functions questions often test whether you know to protect both the trigger and the app configuration.

---

## Part 3: Secure a Container App

### Step 3.1 - Create a Container App

1. Deploy a simple Container App in a Container Apps environment
2. Choose one of these ingress patterns:
   - **Internal ingress only** for back-end workloads, or
   - External ingress only when a front-end is required

### Step 3.2 - Review security controls

Inspect:
- Ingress exposure
- Secrets
- Revisions
- Managed identity support

### Step 3.3 - Reduce exposure

For the lab, set the app so it is not broadly internet-exposed unless you explicitly need that for testing.

> For SC-500, the design principle matters: minimize exposure and prefer managed identity over secrets.

---

## Part 4: Protect back-end APIs with API Management

### Step 4.1 - Create or reuse APIM

1. Open your API Management instance
2. Import or create a simple API for the App Service or Function App backend

### Step 4.2 - Add inbound protection

Apply security policies such as:

- `validate-jwt` to require a valid token
- `rate-limit-by-key` or subscription key control for caller throttling
- Header filtering or transformation if needed

### Step 4.3 - Protect the back end

Where supported:
- Use **managed identity** for outbound calls from APIM
- Restrict the back-end app so APIM is the intended caller

> This is the generic non-AI version of the same idea you practiced in the AI Gateway lab.

---

## Part 5: Compare the service-native controls

Create this mental map:

| Service | Most likely exam controls |
| --- | --- |
| App Service | Entra auth, access restrictions, private endpoints, TLS, Key Vault references |
| Functions | Entra auth, trigger auth, access restrictions, private endpoints, managed identity |
| Container Apps | Ingress mode, secrets, managed identity, environment isolation |
| API Management | JWT validation, throttling, backend auth, policy enforcement |

---

## Validation Steps

Confirm all of the following:

- App Service requires authentication
- Function App requires authentication and is not openly exposed without need
- Container App ingress is intentionally chosen and not left overly broad
- APIM enforces at least one security policy in front of a backend API

---

## Exam traps

- **App Service Authentication** is not the same as **network restriction**
- **Functions** need both app auth and secure trigger/network design
- **API Management** protects the API edge and backend policy plane; it is not just a developer portal
- **Managed identity** is usually preferred over app settings with secrets

---

## Cleanup Instructions

1. Delete test platform services if you created them only for the lab
2. Remove temporary IP allow rules
3. Remove test APIs from APIM

---

## References

- <https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization>
- <https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts>
- <https://learn.microsoft.com/en-us/azure/container-apps/security>
- <https://learn.microsoft.com/en-us/azure/api-management/api-management-policies>
