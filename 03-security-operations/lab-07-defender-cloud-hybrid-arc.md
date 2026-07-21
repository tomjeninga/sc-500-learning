# Lab 07: Hybrid Server Posture with Azure Arc and Defender for Servers

## SC-500 Skill Mapping

This lab maps to SC-500 security operations objectives around:

- Extending Microsoft Defender for Cloud to hybrid resources
- Selecting the correct Defender for Servers onboarding path
- Understanding Azure Arc as the preferred bridge for non-Azure server security posture
- Validating posture and workload protection for hybrid servers

---

## Learning Objectives

After completing this lab, you will be able to:

- Explain why Azure Arc is the recommended onboarding path for hybrid servers
- Onboard a non-Azure machine to Azure as an Arc-enabled server
- Enable Defender for Servers for a hybrid machine
- Validate that the Arc-enabled server appears in Defender for Cloud inventory and recommendations
- Distinguish Plan 1 vs Plan 2 in hybrid scenarios

---

## Prerequisites

- Azure subscription with Microsoft Defender for Cloud enabled
- Contributor or Owner permissions in Azure
- One Windows or Linux non-Azure machine you can onboard
  - On-premises machine, local VM, or another cloud VM
- Ability to install the Azure Connected Machine agent on that machine
- Optional but recommended: `03-security-operations/lab-01-defender-cloud.md`

---

## Architecture (in words)

The non-Azure server is connected to Azure by using Azure Arc. Once connected, it becomes an Azure resource that Defender for Cloud can assess and protect. Defender for Servers then layers workload protection and posture insights onto that Arc-enabled machine.

```text
On-premises or non-Azure server
          |
          v
Azure Arc Connected Machine agent
          |
          v
Azure Arc-enabled server resource
          |
          v
Microsoft Defender for Cloud
          |
          +--> Inventory and recommendations
          +--> Defender for Servers capabilities
```

---

> **Depends on:** `03-security-operations/lab-01-defender-cloud.md` if you want the Defender for Cloud experience already set up
> **Reused by:** `03-security-operations/lab-08-defender-cloud-multicloud-connectors.md` as the conceptual bridge for AWS and GCP server onboarding
> **Delete after:** you finish hybrid server posture validation and no longer need the Arc-enabled test machine

## Part 1: Decide the correct onboarding path

Before onboarding anything, lock in the exam decision model:

| Scenario | Preferred path | Why |
| --- | --- | --- |
| On-premises or non-Azure server | Azure Arc | Gives the broadest Defender for Servers capabilities |
| Direct server protection without Arc | Defender for Endpoint direct onboarding | Useful when Arc is not feasible, but with reduced Plan 2 coverage |
| AWS or GCP VMs | Multicloud connector with Arc autoprovisioning | Standardized onboarding and posture at scale |

**Why this control, not the distractor:**
- Use **Azure Arc** when you want Defender for Cloud to treat the machine like an Azure resource
- Use **direct Defender for Endpoint onboarding** only when Arc is not possible or you intentionally accept narrower capabilities

---

## Part 2: Prepare Azure Arc onboarding

### Portal path

1. Sign in to the Azure portal
2. Open **Azure Arc** -> **Machines**
3. Select **Add/Create** -> **Add a machine**
4. Choose the onboarding option for a single server or at scale

### What to review before deployment

Confirm:

- The operating system is supported by Azure Arc
- The machine can reach required Azure endpoints
- You have local admin rights on the server
- You understand whether you are onboarding a single machine or preparing a scaled rollout

> Azure Arc is the recommended method for onboarding non-Azure machines into Defender for Cloud.

---

## Part 3: Connect the hybrid machine to Azure Arc

### Step 3.1 - Generate onboarding script

1. In the Azure Arc onboarding flow, select your:
   - Subscription
   - Resource group
   - Region
2. Generate the onboarding script

### Step 3.2 - Run the script on the server

1. Sign in to the hybrid machine
2. Run the generated script with local admin privileges
3. Wait for the Azure Connected Machine agent installation to complete

### Step 3.3 - Verify Arc connection

1. Return to **Azure Arc** -> **Machines**
2. Confirm the machine appears as **Connected**

---

## Part 4: Enable Defender for Servers for the Arc-enabled machine

### Step 4.1 - Enable the plan

1. Open **Microsoft Defender for Cloud** -> **Environment settings**
2. Select the subscription where the Arc-enabled machine resource lives
3. Turn on **Defender for Servers**
4. For the lab, choose:
   - **Plan 1** if you want the lowest paid scope
   - **Plan 2** if you want to study the fuller hybrid feature set

### Step 4.2 - Understand the plan choice

| Plan | Hybrid takeaway |
| --- | --- |
| Plan 1 | Entry-level EDR and core server protection |
| Plan 2 | Adds agentless scanning, FIM, JIT, OS configuration assessment, and other richer protections |

**Important exam distinction:**
- Defender for Servers **Plan 2** gives the richer hybrid story
- If you skip Azure Arc and use direct onboarding, you do not get the full Plan 2 experience

---

## Part 5: Validate Defender for Cloud posture on the hybrid server

### Step 5.1 - Check inventory

1. In Defender for Cloud, open **Inventory**
2. Filter for:
   - **Azure Arc-enabled server**, or
   - The machine name you onboarded
3. Confirm the hybrid machine appears in inventory

### Step 5.2 - Review recommendations

1. Open the Arc-enabled server resource from Defender for Cloud
2. Review any recommendations or security findings
3. Note whether you see server hardening or vulnerability-related posture signals

### Step 5.3 - Review MDE integration expectations

Confirm you understand that Defender for Servers relies on Defender for Endpoint integration for threat detection and related capabilities.

---

## Validate

Confirm all of the following:

- The machine is connected as an Azure Arc-enabled server
- The Arc-enabled server appears in Defender for Cloud inventory
- Defender for Servers is enabled for the relevant scope
- You can explain why Azure Arc is preferred over direct onboarding for full hybrid coverage
- You can explain the key difference between Plan 1 and Plan 2 for hybrid servers

### PowerShell validation

```powershell
Get-AzConnectedMachine | Format-Table Name, Status, Location, ResourceGroupName

Get-AzSecurityPricing | Where-Object {$_.Name -eq "VirtualMachines"} |
  Select-Object Name, PricingTier, SubPlan | Format-Table
```

---

## Exam Traps

- **Azure Arc** is the preferred onboarding path for hybrid and multicloud servers when you want the broadest Defender for Servers coverage
- **Direct onboarding with Defender for Endpoint** can still protect servers, but it does not replace Azure Arc for the full Plan 2 story
- **Plan 1** and **Plan 2** are not interchangeable; Plan 2 adds several posture and hardening capabilities that matter in scenario questions
- Defender for Servers is a **CWPP** capability, while broader posture and Secure Score align to **CSPM**

---

## Cleanup

1. Disconnect or delete the Arc-enabled server resource if it was created only for the lab
2. Uninstall the Azure Connected Machine agent from the test server if appropriate
3. Disable Defender for Servers if you enabled it only for temporary study use

---

## References

- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-machines>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/plan-defender-for-servers-select-plan>
- <https://learn.microsoft.com/en-us/training/modules/secure-azure-arc-enabled-servers/>
