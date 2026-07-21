# Lab 03: PIM, Access Reviews, and Access Packages

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** $0 (requires Microsoft Entra ID P2 for PIM and Access Reviews)  
**Difficulty:** Intermediate  
**Requires:** Microsoft Entra ID P2 and at least 3-4 test users/groups

---

## What You'll Build and WHY

You will convert privileged access from standing access to just-in-time access,
configure an approval-based PIM activation flow, run an Access Review for a
privileged group, and publish an Access Package for time-bound onboarding.

**Why this matters for SC-500:**
- SC-500 frequently tests **which governance control** solves an access problem
- PIM, Access Reviews, and Access Packages are complementary, not interchangeable
- Many exam scenarios ask how to reduce standing privilege without breaking operations

**Architecture:**

```text
Entra ID
  ├── Group: grp-sc500-privileged
  │     └── Eligible for Security Administrator (via PIM)
  ├── Access Review
  │     └── Reviews membership in grp-sc500-privileged every 30 days
  └── Access Package
        └── Grants time-bound access to a lab group for new joiners
```

---

## Prerequisites

- Global Administrator or Privileged Role Administrator role
- Microsoft Entra ID P2
- Test identities from Module 1 Lab 01
- One security group for privileged operations, such as `grp-sc500-privileged`

---

## Part 1: Configure PIM for a privileged assignment

### Step 1.1 - Create or reuse a privileged group

1. Open **Microsoft Entra admin center** -> **Groups** -> **All groups**
2. Create a new **Security** group if needed:
   - **Name:** `grp-sc500-privileged`
   - **Membership type:** Assigned
3. Add one or two test users as members

### Step 1.2 - Make the assignment eligible instead of active

1. Open **Microsoft Entra ID** -> **Privileged Identity Management**
2. Go to **Microsoft Entra roles** -> **Assignments**
3. Choose a role such as **Security Administrator**
4. Click **Add assignments**
5. Select `grp-sc500-privileged`
6. Set **Assignment type** to **Eligible**
7. Save the assignment

> Goal: the group should no longer have permanent standing access. Members must
> activate when they need the role.

### Step 1.3 - Configure activation settings

1. In PIM, open **Microsoft Entra roles** -> **Roles** -> **Security Administrator**
2. Open **Settings**
3. Configure:
   - **Activation maximum duration:** 4 hours
   - **Require MFA on activation:** Yes
   - **Require justification:** Yes
   - **Require approval to activate:** Yes
4. Add an approver such as `alice-admin`
5. Save

---

## Part 2: Test an activation flow

### Step 2.1 - Activate the role

1. Sign in as a test user who is a member of `grp-sc500-privileged`
2. Open **My roles** in PIM
3. Under **Eligible assignments**, find **Security Administrator**
4. Click **Activate**
5. Enter a justification such as:
   - `Need temporary access to review Conditional Access impact`
6. Complete MFA if prompted

### Step 2.2 - Approve the request

1. Sign in as the approver
2. Open **Approve requests**
3. Review the request details and justification
4. Approve
5. Confirm the requesting user now has the role temporarily

### Step 2.3 - Review the audit trail

1. In PIM, open **Audit history**
2. Confirm you can see:
   - Request submitted
   - Approval decision
   - Activation completed
   - End time for the assignment

---

## Part 3: Run an Access Review

### Step 3.1 - Create the review

1. Open **Identity Governance** -> **Access reviews**
2. Click **+ New access review**
3. Scope the review to:
   - **Teams + Groups**
   - Group: `grp-sc500-privileged`
4. Configure:
   - **Reviewers:** Group owners or selected users
   - **Frequency:** Monthly
   - **Duration:** 7 days
   - **If reviewers don't respond:** Remove access
5. Save

### Step 3.2 - Review the results

1. Start the review cycle
2. Approve one user and deny another test user
3. Confirm the denied user is removed after completion

> Access Reviews answer: **Who should still have access?**

---

## Part 4: Publish an Access Package

### Step 4.1 - Create a catalog

1. Open **Identity Governance** -> **Entitlement management**
2. Create a catalog named `SC500 Lab Access`

### Step 4.2 - Add resources

1. Add `grp-sc500-contributors` or another lab group to the catalog
2. Confirm the catalog owner can manage access

### Step 4.3 - Create the package

1. Create a new **Access Package**
2. Name: `SC500 Contributor Starter Access`
3. Add the lab group as the included resource role
4. Configure policy:
   - Require approval
   - Requestors: internal users only
   - Expiration: 30 days
   - Require access review: Yes

### Step 4.4 - Request access

1. Use a test user to request the package
2. Approve the request
3. Confirm the user receives the group membership

> Access Packages answer: **How do users request time-bound access in a governed way?**

---

## Validation Steps

```powershell
# Review privileged group membership
Get-MgGroupMember -GroupId <grp-sc500-privileged-object-id>

# Review PIM requests and approvals in portal
# Entra admin center -> PIM -> Audit history

# Review access review results in portal
# Entra admin center -> Identity Governance -> Access reviews
```

Confirm all of the following:
- The privileged role is **eligible**, not permanently active
- Activation requires MFA, justification, and approval
- Access Review can remove stale privileged access
- Access Package grants time-bound access via request/approval

---

## Exam traps

- **PIM** = just-in-time privileged activation
- **Access Review** = periodic attestation of existing access
- **Access Package** = request-based access lifecycle and onboarding
- If the question says **remove standing admin rights**, think **PIM**
- If the question says **certify that access is still required**, think **Access Reviews**
- If the question says **request access to multiple resources with approval**, think **Access Package**

---

## Cleanup Instructions

1. Remove the test Access Package if you no longer need it
2. Delete the review after capturing screenshots/notes
3. Leave the PIM configuration in place if you want to keep practicing

---

## References

- <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure>
- <https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview>
- <https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview>
