# Lab 04: VM Security with Defender for Servers, JIT, and Trusted Launch

## Overview

**Estimated Time:** 60-90 minutes  
**Estimated Cost:** ~$2-6 depending on VM runtime and Defender plan usage  
**Difficulty:** Intermediate

---

## What You'll Build and WHY

You will secure a virtual machine by enabling Defender for Servers, configuring
just-in-time (JIT) VM access, validating trusted launch protections such as
secure boot and vTPM, and reviewing vulnerability and agentless scanning.

**Why this matters for SC-500:**
- The exam expects you to know which VM protections live in **Defender for Servers**
- Many candidates know NSGs but miss JIT, trusted launch, and Defender settings
- Hybrid and multicloud server security questions often start from these same controls

**Architecture:**

```text
Defender for Cloud
  -> Defender for Servers plan
  -> JIT VM access
  -> Vulnerability / agentless scanning

Azure VM
  -> Trusted launch
  -> Secure boot
  -> vTPM
```

---

> **Depends on:** a test VM in `rg-sc500-lab` and Microsoft Defender for Cloud access on the subscription
> **Reused by:** `03-security-operations/lab-01-defender-cloud.md`
> **Delete after:** you finish the Defender for Cloud follow-up lab and any JIT or trusted launch validation

## Prerequisites

- A test VM in `rg-sc500-lab` such as `vm-frontend-01`, or create a new one
- Contributor or Security Admin role
- Defender for Cloud available on the subscription

---

## Part 1: Create or inspect a secure VM baseline

### Step 1.1 - Create a trusted launch VM if needed

If your existing VM was not created with modern security settings, deploy a new
Generation 2 VM and configure:

- **Security type:** Trusted launch
- **Secure boot:** Enabled
- **vTPM:** Enabled

If you already have a trusted launch VM, review its settings instead.

### Step 1.2 - Review VM security settings

1. Open the VM
2. Review:
   - **Security type**
   - **Secure boot**
   - **vTPM**
   - **Boot diagnostics**

> Trusted launch is a platform protection baseline. It is not the same thing as
> disk encryption or JIT.

---

## Part 2: Enable Defender for Servers

### Step 2.1 - Turn on the plan

1. Open **Microsoft Defender for Cloud**
2. Go to **Environment settings**
3. Select your subscription
4. Under **Defender plans**, turn on **Servers**

### Step 2.2 - Review included protections

Inspect the available settings and features such as:

- Vulnerability assessment / Defender Vulnerability Management integration
- Endpoint detection and response (EDR) integration
- Agentless scanning
- File integrity or configuration monitoring where available

> Exact feature names can change over time, but the exam objective stays the same:
> know what Defender for Servers does and where to enable it.

---

## Part 3: Configure JIT VM access

### Step 3.1 - Enable JIT

1. In **Defender for Cloud**, open **Workload protections** -> **Just-in-time VM access**
2. Select your VM
3. Enable JIT and configure:
   - **Port 22** or **3389**
   - **Allowed source IPs:** your current public IP
   - **Maximum request time:** 3 hours
4. Save

### Step 3.2 - Request temporary access

1. Open the JIT blade again
2. Request access for the needed management port
3. Confirm the NSG rule opens only temporarily

> JIT reduces standing inbound exposure. This is one of the most common VM security
> exam scenarios.

---

## Part 4: Review vulnerability and agentless scanning

### Step 4.1 - Review recommendations

1. Open the VM in **Defender for Cloud**
2. Review recommendations such as:
   - Missing endpoint protection
   - OS vulnerabilities
   - Missing security baseline settings

### Step 4.2 - Review scanning signals

Look for:
- Vulnerability findings
- Inventory and software visibility
- Agentless scan results where supported

### Step 4.3 - Compare agent-based and agentless

Record the difference in your notes:
- **Agent-based** = inside the guest OS
- **Agentless** = cloud-side discovery/scanning without full in-guest agent dependency

---

## Part 5: Validate effective hardening

### Step 5.1 - Check inbound exposure

1. Review the VM **Networking** blade
2. Confirm there is no permanently open management port from the internet
3. If an NSG rule is still broad, tighten it or remove it after JIT testing

### Step 5.2 - Review Defender posture

1. Confirm the VM appears under Defender for Servers coverage
2. Confirm recommendations are visible
3. Confirm JIT is enabled

---

## Validation Steps

```powershell
# Review trusted launch properties
Get-AzVM -ResourceGroupName "rg-sc500-lab" -Name "<vm-name>" -Status |
    Select-Object Name

# Review JIT policy in Defender for Cloud through portal
# Defender for Cloud -> Just-in-time VM access
```

Confirm all of the following:

- The VM uses trusted launch or you understand why it does not
- Secure boot and vTPM are enabled for a trusted launch VM
- Defender for Servers is enabled on the subscription
- JIT access is configured for management ports
- Vulnerability and/or agentless scanning findings are visible

---

## Exam traps

- **JIT VM access** belongs to **Defender for Servers**, not NSGs alone
- **Trusted launch** includes **secure boot** and **vTPM**
- **Agentless scanning** is different from endpoint agents/EDR
- **Azure Arc** is the bridge when the server is hybrid or multicloud

---

## Cleanup Instructions

1. Delete the test VM if it was created only for the lab
2. Turn off JIT or revert settings if the VM is reused elsewhere
3. Leave Defender for Servers on only if you want to keep practicing or monitoring

---

## References

- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-introduction>
- <https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/just-in-time-access-overview>
