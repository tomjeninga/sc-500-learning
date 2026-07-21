# Domain 1 Study Guide: Identity & Governance

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Microsoft Entra ID architecture: tenants, directories, objects
- Role-Based Access Control (RBAC): scopes, built-in roles, custom roles
- Conditional Access: policy anatomy, signals, and controls
- Privileged Identity Management (PIM): just-in-time access, approval workflows
- Multi-Factor Authentication (MFA): methods, registration, enforcement
- Access Reviews: what they are, when to use them, and how to configure them

---

## 1. Microsoft Entra ID (formerly Azure Active Directory)

### What is Entra ID?

Microsoft Entra ID is Microsoft's cloud-based **Identity Provider (IdP)**. It is the authentication and authorization backbone for:

- Microsoft 365 (Exchange, Teams, SharePoint)
- Azure resources (subscriptions, resource groups, resources)
- Third-party SaaS applications (via SAML, OAuth 2.0, OIDC)

> **Real-world context for platform engineers:** When you deploy an Azure VM and need to manage who can RDP into it or who can restart it, you're configuring Entra ID (users/groups) combined with Azure RBAC (role assignments). Entra ID handles *who you are*; RBAC handles *what you can do*.

### Key Concepts

| Concept | Description |
| --------- | ------------- |
| **Tenant** | A dedicated instance of Entra ID for your organization. Each Azure subscription is associated with exactly one tenant. |
| **Directory** | The database inside a tenant that stores users, groups, and app registrations. |
| **User objects** | Human users or service accounts in the directory. |
| **Group objects** | Collections of users (Security groups for RBAC, Microsoft 365 groups for collaboration). |
| **Service Principal** | The identity of an application within a tenant. |
| **Managed Identity** | Azure-native service principal auto-managed by Azure. No credential management needed. |
| **App Registration** | The global definition of an application in Entra ID. |

### Entra ID Licensing Tiers

| Feature | Free | P1 | P2 |
| --------- | ------ | ---- | ---- |
| Basic users/groups | ✅ | ✅ | ✅ |
| MFA per-user | ✅ | ✅ | ✅ |
| Conditional Access | ❌ | ✅ | ✅ |
| PIM | ❌ | ❌ | ✅ |
| Identity Protection | ❌ | ❌ | ✅ |
| Access Reviews | ❌ | ❌ | ✅ |

> **Exam tip:** Many SC-500 questions assume Entra ID P2 licensing. Know what each tier enables.

---

## 2. Role-Based Access Control (RBAC)

### RBAC vs Entra ID Roles

These are two separate role systems — a common exam gotcha:

| | **Azure RBAC** | **Entra ID Roles** |
| - | ---------------- | ------------------- |
| Scope | Management groups, subscriptions, resource groups, resources | Tenant-level only |
| Examples | Owner, Contributor, Reader, Storage Blob Data Contributor | Global Administrator, User Administrator, Security Reader |
| Where assigned | Azure Portal → IAM blade | Entra ID Portal → Roles and administrators |
| Managed by | Azure Resource Manager | Microsoft Graph |

### RBAC Scope Hierarchy

```text
Management Group
  └── Subscription
        └── Resource Group
              └── Resource
```text
Permissions assigned at a higher scope are **inherited** by all child scopes. A `Reader` role at the subscription level means the user can read all resource groups and resources in that subscription.

### Key Built-In Roles

| Role | Description | Use Case |
| ------ | ------------- | ---------- |
| **Owner** | Full access + can assign roles | Subscription owners only |
| **Contributor** | Full access, cannot assign roles | DevOps engineers |
| **Reader** | Read-only | Security auditors |
| **User Access Administrator** | Can assign roles, no resource access | Delegated IAM management |
| **Security Admin** | Can manage security policies | Security team |
| **Security Reader** | Read-only security data | SOC analysts |
| **Storage Blob Data Contributor** | Read/write blob data | App identities |

### Least Privilege Principle

Always assign the **minimum permissions** needed for the task:

- Use built-in roles before creating custom roles
- Assign at the lowest scope possible (resource > resource group > subscription)
- Use groups, not individual users, for role assignments
- Use PIM for privileged roles (see Section 4)

### Custom Roles

When no built-in role fits, create a custom role:

```json
{
  "Name": "VM Start/Stop Operator",
  "IsCustom": true,
  "Description": "Can start and stop VMs but not create or delete.",
  "Actions": [
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/deallocate/action",
    "Microsoft.Compute/virtualMachines/read"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": ["/subscriptions/{subscriptionId}"]
}
```text
---

## 3. Conditional Access

### What is Conditional Access?

Conditional Access is an **if-then policy engine** in Entra ID. It evaluates signals and enforces access controls:

```text
IF (User + App + Location + Device + Risk) THEN (Allow | Block | Require MFA | Require compliant device)
```text
> **Real-world context:** Your organization wants to allow employees to access the Azure Portal, but only if they're using a company-managed device AND have completed MFA. You create a Conditional Access policy that targets the "Microsoft Azure Management" app, requires MFA (control), and requires a Hybrid Azure AD joined device (condition).

### Policy Anatomy

**Assignments (signals):**

- **Users and groups** — who the policy applies to
- **Cloud apps or actions** — which applications (e.g., Microsoft Azure Management, All apps)
- **Conditions:**
  - Sign-in risk (Identity Protection)
  - User risk (Identity Protection)
  - Device platform (Windows, iOS, Android)
  - Location (named locations, IP ranges)
  - Client apps (browser, modern auth, legacy auth)

**Access Controls (enforcement):**

- **Grant controls:** Block access | Require MFA | Require compliant device | Require Hybrid AD join | Require approved app
- **Session controls:** Sign-in frequency | Persistent browser session | Conditional Access App Control (MCAS)

### Policy Modes

| Mode | Behaviour |
| ------ | ----------- |
| **Report-only** | Evaluates the policy but does NOT enforce — logs the outcome. Use to test impact. |
| **On** | Full enforcement |
| **Off** | Policy disabled |

> **Exam tip:** Always use **report-only** mode first to understand the impact before enabling a new policy. This is a best practice question on the exam.

### Common Policy Patterns

**Require MFA for administrators:**

- Users: All directory roles (Global Admin, Security Admin, etc.)
- Apps: Any cloud app
- Grant: Require multi-factor authentication

**Block legacy authentication:**

- Users: All users
- Apps: Any cloud app
- Conditions → Client apps: Exchange ActiveSync clients + Other clients
- Grant: Block access

**Location-based access:**

- Users: All users
- Apps: Any cloud app
- Conditions → Locations: All locations, Exclude trusted locations
- Grant: Require MFA (or Block)

---

## 4. Privileged Identity Management (PIM)

### What is PIM?

PIM provides **just-in-time (JIT)** privileged access. Instead of permanently assigning high-privilege roles, PIM allows users to *activate* roles when needed, for a limited duration.

> **Real-world context:** Your security engineer needs Global Administrator access to complete a quarterly audit. Instead of permanently assigning Global Admin (a significant security risk), you use PIM to make them *eligible* for the role. They activate it for 4 hours, providing justification and completing MFA. After 4 hours, the role automatically expires.

### PIM Concepts

| Term | Description |
| ------ | ------------- |
| **Eligible assignment** | User can activate the role when needed |
| **Active assignment** | User has permanent (or time-bound) active access |
| **Activation** | The process of elevating from eligible to active |
| **Activation duration** | Maximum time the role is active (default: 8 hrs) |
| **Justification** | Required explanation when activating a role |
| **Approval workflow** | Designated approvers must approve activation requests |
| **Access Review** | Periodic review to verify role assignments are still needed |
| **Alert** | Notifications for suspicious PIM activity |

### PIM Workflow

```text
1. Admin makes user "eligible" for Global Admin via PIM
2. User goes to PIM portal → My roles → Activate
3. User enters justification, completes MFA
4. (Optional) Approver is notified and approves
5. Role becomes active for the configured duration
6. Role expires automatically OR user deactivates manually
7. Audit log records all activations
```text
### PIM Settings per Role

For each managed role you can configure:

- Maximum activation duration
- Require MFA on activation
- Require justification
- Require approval + specify approvers
- Send notifications
- Require access review

---

## 5. Multi-Factor Authentication (MFA)

### MFA Methods (in order of security)

| Method | Security Level | Notes |
| -------- | --------------- | ------- |
| FIDO2 security key | ★★★★★ | Phishing-resistant |
| Microsoft Authenticator (passwordless) | ★★★★ | Push notification or number match |
| Certificate-based authentication | ★★★★ | Smart card equivalent |
| Microsoft Authenticator (TOTP) | ★★★ | 6-digit code |
| Hardware OATH token | ★★★ | Physical token |
| SMS / Voice call | ★★ | Susceptible to SIM swap — avoid for admins |
| Email OTP | ★★ | For external/guest users |

### MFA Enforcement Options

1. **Per-user MFA** — Legacy method, applies MFA to specific users regardless of conditions. Not recommended for new deployments.
1. **Conditional Access** — Modern approach. MFA required based on policy conditions. Recommended.
1. **Security Defaults** — Free Entra ID feature that enforces MFA for all users. No customization.

> **Exam tip:** Security Defaults and Conditional Access are mutually exclusive — you must disable Security Defaults before creating Conditional Access policies.

---

## 6. Access Reviews

### What are Access Reviews?

Access Reviews are scheduled reviews where designated reviewers confirm or deny that users still need their access to roles, groups, or applications.

**Use cases:**

- Quarterly review of who has Owner/Contributor on production subscriptions
- Monthly review of external (guest) users' access
- Review of PIM eligible role assignments

### Access Review Configuration

| Setting | Options |
| --------- | --------- |
| **Scope** | Users, Groups, Service Principals |
| **Review target** | Group membership, App assignment, Entra ID role, Azure RBAC role |
| **Reviewers** | Users themselves (self-review), Manager, Group owner, Selected reviewers |
| **Frequency** | One-time, Weekly, Monthly, Quarterly, Semi-annually, Annually |
| **Auto-apply** | Automatically remove access if reviewer denies or doesn't respond |
| **Inactive users** | Apply recommendation to remove users with no sign-in for N days |

---

## Zero Trust and Identity

The Zero Trust model has three principles:

1. **Verify explicitly** — Always authenticate and authorize based on all available signals
1. **Use least privilege access** — Limit user access with just-in-time and just-enough-access
1. **Assume breach** — Minimize blast radius, verify end-to-end encryption, use analytics

Identity is the foundation. Entra ID, RBAC, Conditional Access, and PIM are the primary tools to implement Zero Trust for identity.

---

## Comparison: Identity Security Controls

| Control | Purpose | Requires P2? |
| --------- | --------- | ------------- |
| RBAC | Who can do what to which resource | No |
| Conditional Access | When and how access is granted | P1 |
| PIM | Just-in-time privileged access | P2 |
| Identity Protection | Risk-based sign-in policies | P2 |
| Access Reviews | Periodic attestation of access | P2 |
| MFA | Verify identity with second factor | No (P1 for CA) |

---

## Self-Check Questions

1. A user is assigned the `Reader` role at the subscription level and `Contributor` at a specific resource group. What is their effective permission on resources in that resource group?

1. You want to ensure no Azure resource is created without a required `CostCenter` tag. Which service and feature would you use?

1. What is the difference between an **eligible** and an **active** PIM assignment?

1. Your organization's Conditional Access policy requires a **compliant device** for access to Azure Portal. A user complains they cannot access the portal from their personal laptop. What is the likely reason, and what would you advise?

1. Why is blocking **legacy authentication** important for security?

1. What happens to a PIM role activation when the configured maximum duration expires?

1. You want to review all users who have permanent `Owner` role on your production subscription. Which feature do you configure?

---

## Microsoft Learn Resources

- [SC-500: Implement identity and access management](https://learn.microsoft.com/en-us/training/paths/implement-identity-access-management/)
- [What is Privileged Identity Management?](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
- [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
- [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access)
- [What is Azure RBAC?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)
