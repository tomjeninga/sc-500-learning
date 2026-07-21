# Lab 08: Compact Network Breadth Validation

## SC-500 Skill Mapping

This lab maps to the remaining SC-500 networking objectives around:

- Evaluating effective security rules with Azure Network Watcher diagnostics
- Implementing and configuring Azure Firewall
- Configuring network access policies with Azure Virtual Network Manager
- Configuring security for Azure Virtual WAN
- Configuring security for VPN connections
- Implementing and configuring Microsoft Entra Private Access
- Configuring Azure Private Link services

---

## Learning Objectives

After completing this lab, you will be able to:

- Use Network Watcher effective security rules and IP flow verify against an existing VM
- Explain where Azure Virtual Network Manager admin rules sit relative to NSGs
- Build the right decision model for Azure Firewall, Virtual WAN secured hubs, VPN, Entra Private Access, and Private Link service
- Create a small Azure Firewall policy object so the rule types stop feeling abstract

---

## Prerequisites

- Azure subscription with Contributor permissions
- Existing VNet and at least one VM or NIC from `lab-01-network-security.md`
- Optional context from `lab-03-private-access-patterns.md` and `lab-04-vm-security.md`
- Ability to use the Azure portal

---

## Architecture (in words)

This lab reuses an existing VNet and VM as the validation target for Network Watcher. The rest of the lab is a compact control-boundary exercise: you create or review a lightweight Azure Firewall policy object and then map the remaining network services to the right exam scenarios.

```text
Existing VNet and VM
        |
        v
Azure Network Watcher
  |- Effective security rules
  |- IP flow verify

Optional lightweight config object
        |
        v
Azure Firewall Policy

Decision coverage
  |- Azure Virtual Network Manager admin rules
  |- Azure Virtual WAN secured hub
  |- VPN security
  |- Microsoft Entra Private Access
  |- Private Link service
```

---

> **Depends on:** `02-platform-protection/lab-01-network-security.md` and an existing VM or NIC to inspect
> **Reused by:** no required follow-up lab; this is a compact closure lab for the remaining Module 2 networking bullets
> **Delete after:** you finish Network Watcher validation and no longer need the temporary Azure Firewall policy object

## Part 1: Lock in the remaining control boundaries

Before opening any portal blade, make sure you can separate these controls:

| Control | Main security purpose | Best exam clue |
| --- | --- | --- |
| Network Watcher effective security rules | Shows the aggregated rules on a NIC | "Which rule is actually applying to this VM?" |
| IP flow verify | Tests whether a packet is allowed or denied | "Why is this flow blocked?" |
| Azure Firewall | Centralized L3-L7 filtering, DNAT, and FQDN-based egress control | "Inspect and control traffic centrally" |
| Azure Virtual Network Manager | Centralized network groups and security admin rules | "Enforce org-wide rules before local NSGs" |
| Azure Virtual WAN secured hub | Managed hub security and routing at scale | "Secure many sites or spokes through a hub" |
| VPN | Private connectivity from users or sites to Azure | "Need tunnel-based connectivity" |
| Microsoft Entra Private Access | Identity-aware replacement path for access to private apps | "Reduce VPN dependency for user-to-app access" |
| Private Link service | Publish your own service privately behind a Standard Load Balancer | "Expose my service privately to other consumers" |

**Why this control, not the distractor:**
- **Entra Private Access** is not the same thing as a site-to-site or point-to-site VPN
- **Private Endpoint** consumes a private service; **Private Link service** publishes one
- **Azure Firewall** is not just a bigger NSG; it adds centralized policy, DNAT, and application-rule scenarios
- **Azure Virtual Network Manager** security admin rules can take precedence over downstream NSG choices

---

## Part 2: Validate effective rules with Network Watcher

### Step 2.1 - Open effective security rules

1. Open the target VM
2. Open its network interface
3. Go to **Effective security rules** in Azure Network Watcher
4. Review both inbound and outbound rules
5. Download the rules if you want a CSV copy for notes

Record at least:

- one rule you expected to see
- one default rule that still matters
- whether the rule came from subnet scope or NIC scope

### Step 2.2 - Run IP flow verify

1. In Azure Network Watcher, open **IP flow verify**
2. Select the same VM or NIC
3. Test one traffic flow that should be allowed
4. Test one traffic flow that should be denied

Good example checks:

- inbound management traffic that should be denied if you did not intentionally expose it
- outbound HTTPS that should be allowed
- optional east-west traffic between tiers if you created scoped NSG rules in Lab 01

### Step 2.3 - Capture the exact reason for the result

For each IP flow verify test, note:

- whether the result was **Access allowed** or **Access denied**
- the rule name returned by Network Watcher
- whether the rule was a custom rule or a default rule

> IP flow verify tests TCP and UDP flows and is one of the cleanest ways to prove that you understand how Azure evaluates the final rule set.

---

## Part 3: Create a compact Azure Firewall policy object

This is the only new object in the lab. Keep it lightweight. You do not need to deploy a full firewall instance unless you explicitly want extra practice.

### Step 3.1 - Create the policy object

1. Open **Azure Firewall Manager** or **Firewall policies**
2. Create a new firewall policy
3. Suggested name: `afwp-sc500-breadth`
4. Place it in your lab resource group

### Step 3.2 - Add one example of each rule type

Add or sketch these rule patterns in the policy:

| Rule type | Example purpose |
| --- | --- |
| Network rule | Allow TCP 1433 from an app subnet to a specific private SQL target |
| Application rule | Allow HTTPS only to approved FQDNs |
| NAT rule | Publish or translate inbound traffic to a specific internal target |

You do not need to overbuild the values. The goal is to be able to explain which scenario belongs to which rule family.

### Step 3.3 - State the architecture answer

Write down the exact distinction:

- **NSG**: distributed packet filtering on subnet or NIC
- **Azure Firewall**: centralized policy and routing enforcement
- **WAF**: HTTP/S protection for web requests

---

## Part 4: Map the centralized network controls

### Step 4.1 - Review Azure Virtual Network Manager precedence

Use the effective-rules results from Part 2 to lock in this exam rule:

- effective rules can include both NSG rules and Azure Virtual Network Manager admin rules
- security admin rules are designed for central governance across many VNets

Capture this mini-note:

| AVNM rule action | Meaning |
| --- | --- |
| Allow | Traffic is allowed, but downstream NSGs can still deny it |
| Always Allow | Traffic must pass regardless of lower-priority rules or NSGs |
| Deny | Traffic is blocked before downstream NSGs can change the outcome |

### Step 4.2 - Review when Virtual WAN is the better answer

Use this decision model:

- choose **hub-spoke with Azure Firewall** when the environment is smaller and you want direct control over hub resources
- choose **Azure Virtual WAN secured hub** when you need simplified branch, hub, and large-scale routing/security management across sites or regions

### Step 4.3 - Review VPN versus Entra Private Access

Use this short comparison:

| Requirement | Better fit |
| --- | --- |
| Connect a site or device network into Azure using tunnels | VPN |
| Give users identity-aware access to private apps without relying on traditional VPN access patterns | Microsoft Entra Private Access |

> The exam trap is treating Entra Private Access like a generic network tunnel. It is closer to private application access with identity and Conditional Access controls.

---

## Part 5: Close the Private Link service gap

### Step 5.1 - Separate provider and consumer roles

Review the distinction:

| Service | Role |
| --- | --- |
| Private Endpoint | Consumer connects privately to a specific service instance |
| Private Link service | Provider publishes its own service privately behind a Standard Load Balancer |

### Step 5.2 - Lock in the scenario answer

Use this rule:

- if you are securing access to **Azure Storage, SQL, Key Vault, or another PaaS resource**, you usually consume it with a **Private Endpoint**
- if you are exposing **your own service privately** to other VNets or tenants, you use **Private Link service**

---

## Validate

Confirm all of the following:

- You used **Effective security rules** on a real NIC or VM
- You used **IP flow verify** for one allowed and one denied path
- You can explain why Network Watcher shows the final applied rule outcome rather than just the NSG object in isolation
- You created or reviewed a compact Azure Firewall policy with network, application, and NAT rule examples
- You can explain the precedence relationship between Azure Virtual Network Manager admin rules and NSGs
- You can explain when Azure Virtual WAN secured hub is the better answer than a small bespoke hub build
- You can explain when VPN is still the right answer and when Microsoft Entra Private Access is the better fit
- You can explain **Private Endpoint** versus **Private Link service** without mixing provider and consumer roles

---

## Exam Traps

- **Effective security rules** show the aggregated outcome; they are not just a copy of one NSG
- **IP flow verify** answers "allowed or denied and by which rule," which makes it more precise than guessing from the portal
- **Azure Virtual Network Manager** security admin rules are a central-governance layer, not just another local NSG
- **Azure Firewall** is the stronger answer when the scenario needs centralized routing and FQDN-aware filtering
- **Azure Virtual WAN** is about scaled network connectivity and secured hubs, not just "another VNet"
- **Microsoft Entra Private Access** is not a replacement for every VPN scenario, especially site-to-site connectivity
- **Private Link service** is for privately publishing your own service; **Private Endpoint** is for consuming one privately

---

## Cleanup

1. Delete the temporary Azure Firewall policy if you created it only for this lab
2. Remove any notes or exports that contain internal IP addressing if you do not want to keep them
3. Keep the VM and VNet only if you still need them for other labs

---

## References

- <https://learn.microsoft.com/en-us/azure/network-watcher/effective-security-rules-overview>
- <https://learn.microsoft.com/en-us/azure/network-watcher/ip-flow-verify-overview>
- <https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/>
- <https://learn.microsoft.com/en-us/azure/virtual-network-manager/overview>
- <https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access>
- <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview>
- <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about>
- <https://learn.microsoft.com/en-us/azure/virtual-wan/manage-secure-access-resources-spoke-p2s>
