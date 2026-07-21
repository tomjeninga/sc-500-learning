# Domain 2 Study Guide: Platform Protection

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Network segmentation: VNets, subnets, peering, and the hub-spoke model
- Network Security Groups (NSGs): rules, priorities, flow logs
- Application Security Groups (ASGs): simplifying NSG rules at scale
- Azure Firewall: DNAT, network rules, application rules, threat intelligence
- Azure DDoS Protection: Basic vs Standard
- Web Application Firewall (WAF): App Gateway, Front Door, OWASP rulesets
- Private Endpoints vs Service Endpoints
- Azure Bastion: secure RDP/SSH without public IPs
- Encryption in transit: TLS/HTTPS enforcement
- Encryption at rest: server-side encryption, CMK, Azure Disk Encryption
- AKS and ACR security controls, workload identity, and Defender for Containers
- App platform protection for Container Apps, Logic Apps, App Service, Functions, and API Management

---

## 1. Network Segmentation in Azure

### VNet and Subnet Design

Azure Virtual Networks (VNets) are the foundation of network isolation in Azure. Resources within a VNet can communicate by default; resources in different VNets cannot (unless peered).

**Best practice subnet layout for a secure workload:**

```
VNet: 10.0.0.0/16
├── Subnet: snet-frontend  10.0.1.0/24  ← Web tier (public-facing)
├── Subnet: snet-backend   10.0.2.0/24  ← App tier (private)
├── Subnet: snet-data      10.0.3.0/24  ← Database tier (private)
├── Subnet: AzureBastionSubnet  10.0.4.0/27  ← Required for Azure Bastion
└── Subnet: AzureFirewallSubnet 10.0.0.0/26  ← Required for Azure Firewall
```

> **Real-world context for platform engineers:** A typical 3-tier application separates web, app, and database tiers into separate subnets with NSG rules that only allow traffic between tiers on specific ports. This limits the blast radius if any tier is compromised.

### Hub-Spoke Network Topology

A hub-spoke topology is the recommended Azure landing zone pattern:

```
Hub VNet (shared services)
├── Azure Firewall (centralized egress)
├── Azure Bastion (centralized management access)
├── VPN/ExpressRoute Gateway (on-premises connectivity)
└── Spoke VNet 1 (workload A) ─── peering ───┐
└── Spoke VNet 2 (workload B) ─── peering ───┤── connected to Hub
└── Spoke VNet N (workload N) ─── peering ───┘
```

**Benefits:**
- Centralized security controls (all internet-bound traffic through Firewall)
- Reduced cost vs deploying Firewall in each spoke
- Simplified routing with User Defined Routes (UDRs)

---

## 2. Network Security Groups (NSGs)

### What is an NSG?

An NSG is a stateful layer-4 firewall (TCP/UDP/ICMP) that can be attached to:
- **Subnet** — applies to all resources in the subnet
- **Network Interface Card (NIC)** — applies to a specific VM

### NSG Rule Properties

| Property | Description |
|----------|-------------|
| **Priority** | 100–4096. Lower = higher priority. Rule evaluation stops at first match. |
| **Source/Destination** | IP address, CIDR range, Service Tag, or ASG |
| **Port/Protocol** | Specific port, range, or * (any) |
| **Action** | Allow or Deny |
| **Direction** | Inbound or Outbound |

### Default NSG Rules (always present, cannot be deleted)

**Inbound defaults:**
- Priority 65000: Allow VNet inbound (all VNet traffic)
- Priority 65001: Allow Azure Load Balancer inbound
- Priority 65500: **Deny all inbound** (implicit deny)

**Outbound defaults:**
- Priority 65000: Allow VNet outbound
- Priority 65001: Allow internet outbound (all outbound to internet is ALLOWED by default)
- Priority 65500: Deny all outbound

> **Exam tip:** Outbound internet traffic is ALLOWED by default in NSGs. You must explicitly deny it if needed.

### Service Tags

Service tags represent groups of IP ranges for Azure services:
- `Internet` — public IP addresses
- `AzureCloud` — all Azure datacenter IP ranges
- `VirtualNetwork` — all addresses in the VNet and peered VNets
- `AzureLoadBalancer` — Azure load balancer probes
- `Storage` — Azure Storage service
- `Sql` — Azure SQL service
- `AppService` — Azure App Service

Example rule: Allow HTTPS from internet to frontend subnet:
```
Priority: 100 | Source: Internet | Destination: snet-frontend | Port: 443 | Allow
```

### Application Security Groups (ASGs)

ASGs let you group VMs by role and use those groups in NSG rules, instead of managing IP addresses:

```
ASG: asg-web-servers  → all web tier VMs
ASG: asg-app-servers  → all app tier VMs
ASG: asg-db-servers   → all database VMs

NSG Rule: Allow TCP 8080 from asg-web-servers to asg-app-servers
NSG Rule: Allow TCP 1433 from asg-app-servers to asg-db-servers
NSG Rule: Deny all from asg-web-servers to asg-db-servers
```

This approach scales cleanly — add a VM to an ASG and it immediately inherits the security rules.

---

## 3. Azure Firewall vs NSG vs WAF

This is a frequently tested comparison:

| Feature | NSG | Azure Firewall | WAF (App Gateway) |
|---------|-----|----------------|-------------------|
| OSI Layer | Layer 4 (L4) | Layer 4 + L7 | Layer 7 (HTTP/S) |
| Protocol support | TCP, UDP, ICMP | TCP, UDP, ICMP, FQDN | HTTP, HTTPS, WebSocket |
| FQDN filtering | ❌ | ✅ (application rules) | ❌ |
| Threat intelligence | ❌ | ✅ | ❌ |
| DNAT (inbound) | ❌ | ✅ | ❌ |
| OWASP protection | ❌ | ❌ | ✅ |
| Cost | Free | ~$1.25/hr + data | ~$0.25/hr + capacity |
| Management | Subnet/NIC | Centralized | Per App Gateway |
| State | Stateful | Stateful | Stateful |

### When to Use Each

| Scenario | Tool |
|----------|------|
| Block all SSH from internet to VMs | NSG (deny inbound TCP 22 from Internet) |
| Allow only specific FQDNs from VMs to internet | Azure Firewall (application rule) |
| Protect a web app from SQLi, XSS attacks | WAF on App Gateway |
| Centralized east-west traffic control | Azure Firewall |
| Per-subnet micro-segmentation | NSG |
| DDoS protection for a specific app | WAF + DDoS Standard |

---

## 4. Azure DDoS Protection

| Tier | Cost | Protection Level |
|------|------|-----------------|
| **Network Protection (Basic)** | Free (included) | Infrastructure-level. Protects all Azure resources from common volumetric DDoS. |
| **Network Protection (Standard)** | ~$2,944/month | Application-specific policies, adaptive tuning, DDoS analytics, cost protection |
| **IP Protection** | ~$199/month per IP | Covers single public IP addresses |

> **Exam tip:** For the exam, know that DDoS Network Protection (Standard) provides **always-on monitoring**, **adaptive tuning** of mitigation policies, and **telemetry** during an attack. Basic DDoS is free but provides no telemetry or SLA guarantees.

---

## 5. Web Application Firewall (WAF)

### WAF Deployment Options

| Platform | Use Case |
|----------|---------|
| **Application Gateway v2** | Single-region HTTP/S load balancer + WAF |
| **Azure Front Door** | Global HTTP/S load balancer + WAF |
| **Azure CDN** | Static content delivery + WAF |

### WAF Modes

| Mode | Behaviour |
|------|-----------|
| **Detection** | Logs suspicious requests but does NOT block them. Use to understand traffic. |
| **Prevention** | Logs AND blocks suspicious requests. Use in production. |

### OWASP Rulesets

WAF protects against the OWASP Top 10 using managed rule sets:
- **OWASP 3.2** — Current recommended ruleset
- **OWASP 3.1** — Previous version (still supported)
- **Bot Manager** — Detects and blocks malicious bots

**Protected attack categories include:**
- SQL Injection (SQLi)
- Cross-Site Scripting (XSS)
- Local File Inclusion (LFI)
- Remote File Inclusion (RFI)
- Protocol violations
- Scanner detection

### Custom WAF Rules

Beyond OWASP, you can create custom rules:
- **Rate limiting** — Block IPs that send more than N requests per minute
- **Geo-filtering** — Block or allow by country
- **IP allow/blocklist** — Explicit IP management

---

## 6. Private Endpoints vs Service Endpoints

| Feature | Private Endpoint | Service Endpoint |
|---------|-----------------|-----------------|
| **What it does** | Creates a private NIC in your VNet for the Azure service | Routes VNet traffic to Azure service over Azure backbone |
| **Traffic path** | Stays entirely within your VNet | Optimized path through Azure backbone, but service is still accessible via public IP |
| **Public IP disabled?** | ✅ Yes (can fully disable public access) | ❌ No — public access still available |
| **DNS** | Requires private DNS zone | No DNS changes needed |
| **Cost** | ~$0.01/hr + $0.01/GB | Free |
| **Use case** | Maximum isolation — databases, Key Vault | Performance for non-sensitive services |

> **Exam tip:** For SC-500, **Private Endpoints** are the recommended approach for securing access to PaaS services (Storage, SQL, Key Vault). They eliminate exposure to the public internet entirely.

---

## 7. Compact Decision Map for the Remaining Network Controls

Use this section together with `lab-08-network-breadth-validation.md`. The goal is not to build every service in depth. The goal is to recognize the correct control boundary in a scenario question.

| Control | What it helps you answer | Best fit |
| --- | --- | --- |
| Network Watcher effective security rules | "Which rule is actually applying to this VM?" | Audit the final inbound and outbound rule set on a NIC |
| IP flow verify | "Why is this packet allowed or denied?" | Test one specific TCP or UDP path against the final rule outcome |
| Azure Firewall | "Which service centrally filters and routes traffic?" | Hub or centralized egress/ingress policy with network, application, or NAT rules |
| Azure Virtual Network Manager | "How do I enforce network guardrails across many VNets?" | Centralized security admin rules and network grouping at scale |
| Azure Virtual WAN secured hub | "How do I secure many branches, sites, or spokes through a managed hub?" | Large-scale connectivity and routing with a managed hub model |
| VPN | "How do I connect users, devices, or sites to Azure over a tunnel?" | Tunnel-based access for site-to-site or point-to-site scenarios |
| Microsoft Entra Private Access | "How do I modernize private app access without relying on a traditional VPN pattern?" | Identity-aware access to private apps with Conditional Access alignment |
| Private Link service | "How do I publish my own service privately to consumers?" | Provider-side private publishing behind a Standard Load Balancer |

### Quick distinction rules

- If you need the **final applied VM rule outcome**, use **Effective security rules** or **IP flow verify**, not just raw NSG inspection.
- If the requirement is **centralized traffic filtering and routing**, prefer **Azure Firewall** over NSG.
- If the requirement is **organization-wide network guardrails**, think **Azure Virtual Network Manager**.
- If the requirement is **large-scale hub, branch, and routing simplification**, think **Azure Virtual WAN secured hub**.
- If the requirement is **identity-aware access to private apps**, think **Microsoft Entra Private Access**, not classic VPN by default.
- If you are **consuming** a private service, think **Private Endpoint**. If you are **publishing** your own service privately, think **Private Link service**.

---

## 8. Azure Bastion

Azure Bastion provides RDP and SSH access to VMs through the Azure Portal over HTTPS, **without exposing port 22 or 3389 to the internet**.

**Benefits:**
- No public IP required on VMs
- No jump box/bastion host to maintain
- RDP/SSH over SSL (port 443) — hard to block by corporate firewalls
- Session recordings available (Premium tier)

**Requirements:**
- Dedicated subnet named `AzureBastionSubnet` (/27 minimum, /26 recommended)
- Public IP on the Bastion resource itself (not the VMs)

---

## 9. Encryption in Transit

All Azure PaaS services enforce **TLS 1.2 or higher** by default. Key controls:

- **Storage accounts:** Configure minimum TLS version (1.2 recommended)
- **Azure SQL:** TLS 1.2 enforced, Encrypt parameter in connection string
- **App Service:** Require HTTPS only (redirect HTTP → HTTPS)
- **Azure Front Door / App Gateway:** Configure TLS policy, disable TLS 1.0/1.1

---

## 10. Encryption at Rest

### Default Encryption

All Azure storage services encrypt data at rest automatically using **Platform-Managed Keys (PMK)**. This is transparent and requires no configuration.

### Customer-Managed Keys (CMK)

Organizations with specific compliance requirements (HIPAA, FedRAMP) may need to manage their own encryption keys:

1. Store key in **Azure Key Vault** (or Key Vault Managed HSM for FIPS 140-2 Level 3)
2. Configure storage/database service to use the Key Vault key
3. Rotate keys on schedule (automatic rotation supported)
4. If the key is disabled/deleted → data becomes inaccessible

### Azure Disk Encryption

For Azure VMs, Azure Disk Encryption (ADE) encrypts OS and data disks using:
- **Windows:** BitLocker
- **Linux:** dm-crypt

ADE keys are stored in Key Vault. This provides **guest-OS level encryption** in addition to the platform-level storage encryption.

---

## Comparison: Encryption Options

| Type | Default? | Key Management | Use Case |
|------|---------|----------------|---------|
| PMK (Server-Side Encryption) | ✅ Yes | Azure-managed | Most workloads |
| CMK (Server-Side Encryption) | ❌ Opt-in | Customer (Key Vault) | Regulated industries |
| Azure Disk Encryption (ADE) | ❌ Opt-in | Customer (Key Vault) | VM disk encryption compliance |
| Double Encryption | ❌ Opt-in | Two layers (PMK + CMK) | Maximum compliance requirement |

---

## 10. Container Platform Security

### AKS security model

For SC-500, think about AKS in four layers:

| Layer | Main controls |
| --- | --- |
| Build pipeline | Image scanning, trusted build path, policy gates |
| Registry | ACR RBAC, disable admin user, restrict network exposure |
| Cluster | Entra integration, Azure RBAC, private or restricted API access, network policy |
| Runtime | Defender for Containers, sensor telemetry, posture recommendations |

### AKS controls to remember

- **Microsoft Entra integration** for user access to the cluster
- **Azure RBAC for Kubernetes authorization** when you want Azure-governed access management
- **Workload identity** when pods need Azure resource access without embedded secrets
- **Authorized IP ranges** or a **private cluster** to reduce Kubernetes API exposure
- **Network policies** to control pod-to-pod communication

> **Exam tip:** If a Kubernetes workload needs access to Key Vault or Storage, workload identity is usually the better answer than a stored secret or a broad node-level credential.

### ACR controls to remember

- Disable the **admin user** unless there is a temporary lab reason to keep it enabled
- Use Azure RBAC roles such as `AcrPull` and `AcrPush`
- Reduce public exposure where possible by using network restrictions or private connectivity
- Treat registry scanning as asynchronous; findings do not always appear immediately after a push

### Defender for Containers

Defender for Containers extends Microsoft Defender for Cloud into Kubernetes and registry scenarios.

Key components include:

- **Defender sensor** for runtime telemetry and threat detection
- **Azure Policy** for Kubernetes posture recommendations
- **Kubernetes API access** for inventory and configuration analysis
- **Registry access** for image vulnerability findings

**Important distinction:**
- Image scanning in ACR is not the same as AKS runtime protection
- AKS is where runtime protection and cluster posture meet

---

## 11. App Platform and Workflow Security

### App Service and Functions

For App Service and Azure Functions, the exam often tests combinations of:

- **Built-in authentication** with Microsoft Entra ID
- **Access restrictions** or private connectivity
- **HTTPS only** and current TLS settings
- **Managed identity** and **Key Vault references** instead of embedded secrets

> **Exam tip:** Authentication and network restriction solve different problems. Requiring sign-in does not automatically mean the app is network-isolated.

### Container Apps

For Azure Container Apps, focus on:

- Intentionally choosing **internal** or **external** ingress
- Using **managed identity** for Azure service access
- Using **Key Vault** or secure secret references rather than plain-text settings
- Keeping environment boundaries clear between production and nonproduction workloads

### Logic Apps

Logic Apps are part of the application platform surface because they can become privileged workflow identities.

Focus on:

- **Managed identity** for workflow access to Azure resources
- Reducing **trigger exposure** when the workflow entry point should not be broadly callable
- Limiting who can view or operate the workflow and its run history
- Avoiding broad connector secrets when platform identity is available

### API Management

API Management is an API security enforcement point, not just a publishing surface.

Common exam controls include:

- `validate-jwt` or `validate-azure-ad-token`
- `rate-limit` or `rate-limit-by-key`
- Backend authentication and trust boundaries
- Using APIM as the intended caller path to the backend API

### Common service comparison

| Service | Most likely exam controls |
| --- | --- |
| App Service | Entra auth, TLS, access restrictions, Key Vault references |
| Functions | Entra auth, trigger protection, network restriction, managed identity |
| Container Apps | Ingress mode, managed identity, secret handling |
| Logic Apps | Managed identity, trigger exposure, workflow access control |
| API Management | Token validation, throttling, backend protection |

---

## Self-Check Questions

1. A VM in `snet-backend` needs to query Azure SQL. The SQL server has a Service Endpoint configured. How does the traffic route, and could you improve this with a Private Endpoint?

2. An NSG has these inbound rules: Priority 100 Allow port 443 from Internet; Priority 200 Deny all from Internet. What happens to an HTTP (port 80) request from the internet?

3. Your WAF is in Detection mode and you're seeing SQLi attempts in the logs. What change do you make, and what impact should you test for?

4. A developer wants to SSH to a VM using its private IP. The VM has no public IP. What Azure service enables this?

5. What is the minimum subnet size for `AzureBastionSubnet`?

6. A storage account needs to be accessible only from a specific VNet subnet. What two options exist, and which provides better security?

7. An organization must prove that the keys encrypting their Azure SQL database are controlled exclusively by them and cannot be accessed by Microsoft. What technology and key storage option do you recommend?

8. An AKS workload needs access to Azure Key Vault without storing credentials in a Kubernetes Secret. What identity pattern is the best fit?

9. A team wants vulnerability findings for container images in ACR and runtime threat protection for workloads in AKS. What Defender capability or capabilities are required?

10. A Logic App can call a backend resource, but the workflow currently stores a secret in its configuration. What platform-native improvement is usually preferred?

11. An API must reject callers without a valid Microsoft Entra token before the request reaches the Function App backend. What Azure service and policy category should you use?

---

## Microsoft Learn Resources

- [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/)
- [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/)
- [Introduction to Azure Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/)
- [Azure Web Application Firewall on Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)
- [Azure Private Endpoint overview](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [Azure Bastion overview](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Security concepts for AKS applications and clusters](https://learn.microsoft.com/en-us/azure/aks/concepts-security)
- [Enable Defender for Containers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-enable-plan)
- [Authentication and authorization in Azure App Service and Azure Functions](https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)
- [Security overview for Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/security)
- [Validate JWT policy in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/validate-jwt-policy)
