# Lab 09: Security Copilot Roles, Plugins, and Agents

## SC-500 Skill Mapping

This lab maps to SC-500 security operations objectives around:

- Configure workspaces for Security Copilot
- Manage permissions and roles
- Enable and configure plugins
- Enable and configure Microsoft agents and Security Store agents

---

## Learning Objectives

After completing this lab, you will be able to:

- Distinguish Security Copilot platform roles from Microsoft Entra roles and Azure RBAC
- Assign Security Copilot owner and contributor access using least privilege
- Prove that plugin access still depends on the underlying product roles, such as Microsoft Sentinel Reader
- Configure a plugin or dependent source and set up a Microsoft-built agent
- Explain how Security Store agents differ from the Security Copilot platform itself

---

## Prerequisites

- A tenant with Microsoft Security Copilot provisioned or included through the applicable Microsoft 365 eligibility path
- A test user or group for contributor access
- Recommended: `03-security-operations/lab-02-sentinel-setup.md` so you have a Sentinel workspace to use for plugin validation
- Optional: `03-security-operations/lab-03-sentinel-triage-investigation.md` if you want a more realistic incident context when testing plugin access

---

## Architecture (in words)

Security Copilot uses its own platform roles, but it does not grant security data access by itself. Users first need Copilot platform access, and then they still need the underlying service roles for the plugins or agents they use.

```text
Security analyst or admin
        |
        +--> Security Copilot platform role
        |      - Copilot owner
        |      - Copilot contributor
        |
        +--> Underlying product RBAC
        |      - Microsoft Sentinel Reader
        |      - Defender XDR or other service roles
        |
        \--> Plugins and agents
               - Microsoft-built agents
               - Security Store agents
```

---

> **Depends on:** `03-security-operations/lab-02-sentinel-setup.md` if you want a concrete Sentinel plugin validation path
> **Reused by:** no required follow-up lab; this is a small operations breadth lab that closes the Security Copilot setup gap
> **Delete after:** you finish role, plugin, and agent validation and no longer need the temporary Copilot assignments or test agent configuration

## Part 1: Confirm the onboarding model

### Step 1.1 - Identify your tenant path

Before changing anything, determine whether your tenant is:

- a Microsoft 365 E5 or E7 customer with Security Copilot included and provisioned, or
- a tenant that required manual onboarding and Security Compute Units (SCUs)

### Step 1.2 - Record the operational impact

Write down which of these applies in your environment:

- whether Security Copilot was already provisioned
- whether SCU capacity is relevant for your tenant
- whether your landing experience is agents-first or chat-first

> **Why this control, not the distractor:** licensing and SCU onboarding determine how you enter the platform. They do not replace Security Copilot RBAC or product-specific plugin permissions.

---

## Part 2: Assign Security Copilot roles

### Step 2.1 - Review owner access

1. Sign in to Security Copilot
2. Open the home menu
3. Go to **Role assignment**
4. Review the current **Copilot owner** assignments

Record these two exam-relevant facts:

- Security Copilot uses its own **owner** and **contributor** roles
- Security Copilot enforces retention of at least two owners

### Step 2.2 - Add a contributor by group

1. In **Role assignment**, select **Add members**
2. Add a security group or test user
3. Assign **Security Copilot contributor**

Prefer a security group over a direct individual assignment when possible.

### Step 2.3 - Compare owner vs contributor

Document the difference:

- **Owner** manages Copilot settings, tenant plugin availability, and role assignments
- **Contributor** can create sessions and use the platform, but does not automatically manage tenant-wide settings

---

## Part 3: Prove that plugin access still depends on the source system

### Step 3.1 - Start with Copilot contributor only

Use a test user or group that has:

- **Security Copilot contributor** access
- no extra Sentinel workspace access yet

### Step 3.2 - Test the Sentinel access path

Attempt to use a Sentinel-related plugin or Copilot workflow that needs Sentinel data.

Record the result.

### Step 3.3 - Add the least underlying role

1. Go to the Sentinel workspace used in `lab-02-sentinel-setup.md`
2. Assign the test user or group the **Microsoft Sentinel Reader** role at the workspace scope
3. Retest the same Copilot or plugin experience

Expected outcome:

- Copilot contributor alone is not enough to access Sentinel data
- The underlying Sentinel RBAC role unlocks the data path

> This is the core Security Copilot identity model: Copilot platform access plus underlying product access.

---

## Part 4: Configure a plugin or dependent source

### Step 4.1 - Review plugin setup behavior

In Security Copilot, inspect the available plugin or source surfaces and find one that shows a setup or gear/configuration flow.

### Step 4.2 - Configure the source

If a plugin requires per-user or dependent configuration:

1. Go to **Manage sources**
2. Find the plugin or dependent source
3. Complete the configuration flow

Record whether the setup is:

- tenant-controlled by an owner
- user-level setup for the signed-in user
- dependent on service-specific roles or authentication

---

## Part 5: Set up a Microsoft-built agent

### Step 5.1 - Open the agent library

1. In Security Copilot, go to **Agents**
2. Select a Microsoft-built agent that is available in your tenant
3. Choose **Set up**

### Step 5.2 - Choose an identity

When prompted, prefer:

- **Create an agent identity** for Microsoft-built agents

Document why this is preferred:

- it scopes the identity to the agent
- it is easier to govern than borrowing a human user account

### Step 5.3 - Review the setup model

During setup, inspect and record the meaning of:

- **Trigger**
- **Permissions**
- **Identity**
- **Plugins**
- **Products**
- **Role-based access**

### Step 5.4 - Run the agent

Finish setup and select **Run**.

If the agent requires an additional permission or plugin dependency, capture that requirement in your notes.

---

## Part 6: Review Security Store agent behavior

### Step 6.1 - Browse Security Store

1. In Security Copilot, open **Security Store**
2. Search for an available agent
3. Review the difference between:
   - a Microsoft-built agent available directly in the agent library
   - an agent acquired through **Security Store**

### Step 6.2 - Record the key distinctions

Write down these points:

- Security Store purchases and subscriptions are separate from the Security Copilot platform
- Using agents in Security Copilot still consumes **SCUs**
- If an acquired agent depends on a plugin, the plugin can be enabled for the agent but still require separate configuration in **Manage sources**

You do not need to purchase an agent for this lab unless your tenant already supports and permits it.

---

## Validate

Confirm all of the following:

- You can explain the difference between **Security Copilot owner/contributor** and the underlying product roles
- A user with **Copilot contributor** access can sign in but does not automatically gain Sentinel data access
- After assigning **Microsoft Sentinel Reader**, the same user can use the Sentinel-backed path more successfully
- You configured or reviewed at least one plugin or dependent source setup flow
- You set up or reviewed a Microsoft-built agent and recorded its identity and permission model
- You can explain how Security Store agents differ from platform access and SCU usage

---

## Exam Traps

- **Security Copilot contributor** does not automatically grant access to Microsoft Sentinel, Defender XDR, Intune, or Purview data
- **Security Copilot roles** are not the same as **Microsoft Entra roles**
- **Security Store** handles acquisition and subscription separately from Security Copilot operations
- An agent can appear available but still fail until the required plugin or source configuration is completed
- Prefer **agent identity** over a human user account when Microsoft-built agent setup supports it

---

## Cleanup

1. Remove any temporary test users or groups from Copilot contributor access if they were created only for this lab
2. Remove temporary Sentinel Reader assignments if they are no longer needed
3. Pause or remove the test agent if it was created only for learning

---

## References

- <https://learn.microsoft.com/en-us/copilot/security/get-started-security-copilot>
- <https://learn.microsoft.com/en-us/copilot/security/authentication>
- <https://learn.microsoft.com/en-us/copilot/security/agents-manage>
- <https://learn.microsoft.com/en-us/copilot/security/agents-overview>
- <https://learn.microsoft.com/en-us/copilot/security/security-store-integration>
