# Domain 2: Platform Protection

## Learning Objectives

By completing this domain, you will be able to:

- Design and implement network segmentation with VNets, subnets, and NSGs
- Configure Application Security Groups (ASGs) for workload-level traffic control
- Understand Azure Firewall vs NSG vs WAF and when to use each
- Configure Azure DDoS Protection (Basic vs Standard)
- Deploy Application Gateway v2 with WAF_v2 and OWASP ruleset
- Implement Private Endpoints and Azure Bastion
- Understand encryption in transit (TLS) and at rest (server-side encryption, disk encryption)
- Compare Private Endpoint vs Service Endpoint for PaaS isolation
- Secure virtual machines with Defender for Servers, JIT, and trusted launch
- Implement application platform security for App Service, Functions, Container Apps, Logic Apps, API Management, AKS, and ACR

---

## Domain Overview

Platform protection secures the **infrastructure layer** — the networks, compute, and storage that your workloads run on. This domain maps to Microsoft's **Secure Network Connectivity** and **Host Security** areas of the Azure Well-Architected Framework security pillar.

### SC-500 Exam Weight: ~20–25%

Expect questions on:
- NSG rules (inbound/outbound, priority, allow/deny)
- Azure Firewall DNAT, network rules, application rules
- WAF modes (Detection vs Prevention), OWASP rulesets
- Private Endpoints vs Service Endpoints
- Bastion deployment and RDP/SSH without public IP
- Encryption at rest options (PMK vs CMK, Azure Disk Encryption)
- JIT VM access, secure boot, vTPM, and Defender for Servers
- App Service and Functions authentication/network restrictions
- AKS and ACR security controls, workload identity, and Defender for Containers
- Logic Apps identity, trigger exposure, and workflow security
- API Management as a protection boundary for back-end APIs

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-network-security.md` | VNet + subnets + NSGs + test VMs | 60–90 min |
| `lab-02-waf-setup.md` | App Gateway v2 + WAF_v2 + OWASP + simulate attacks | 90–120 min |
| `lab-03-private-access-patterns.md` | Private access patterns for Storage + SQL | 60–90 min |
| `lab-04-vm-security.md` | Defender for Servers, JIT, trusted launch, and agentless scanning | 60–90 min |
| `lab-05-app-platform-security.md` | App Service, Functions, Container Apps, and APIM protection | 60–90 min |
| `lab-06-aks-acr-defender-containers.md` | AKS, ACR, workload identity, and Defender for Containers | 60–90 min |
| `lab-07-logic-apps-and-apim-security.md` | Logic Apps identity and API Management policy enforcement | 60–90 min |
| `lab-08-network-breadth-validation.md` | Compact Network Watcher, Azure Firewall, Virtual WAN, and access-model coverage | 30–45 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/vnet-with-nsg.json` | ARM template — VNet with subnets and NSG rules |
| `templates/app-gateway-waf.json` | ARM template — Application Gateway v2 with WAF_v2 |
| `scripts/deploy-network-lab.ps1` | Deploys both templates, validates deployment |

---

## Key Microsoft Learn Links

- [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/)
- [Introduction to Azure Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/)
- [Secure network connectivity on Azure](https://learn.microsoft.com/en-us/training/modules/secure-network-connectivity-azure/)
- [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/)
- [Plan your Defender for Servers deployment](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-introduction)
- [Security in Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/overview-security)
- [Security concepts for AKS applications and clusters](https://learn.microsoft.com/en-us/azure/aks/concepts-security)
- [Enable Defender for Containers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-enable-plan)

---

## Start Here

1. Read `study-guide.md` — understand the network security controls
2. Complete `lab-01-network-security.md` — build VNet + NSG infrastructure
3. Complete `lab-02-waf-setup.md` — deploy and test WAF
4. Complete `lab-03-private-access-patterns.md` — validate Private Endpoints and DNS resolution
5. Complete `lab-04-vm-security.md` — secure a VM with Defender for Servers, JIT, and trusted launch controls
6. Complete `lab-08-network-breadth-validation.md` — close the remaining network-control decision and validation gaps
7. Complete `lab-05-app-platform-security.md` — apply the core app-service controls across platform services
8. Complete `lab-06-aks-acr-defender-containers.md` — extend into container platform and runtime protection
9. Complete `lab-07-logic-apps-and-apim-security.md` — secure workflows and API enforcement paths
10. Run `scripts/deploy-network-lab.ps1` to automate the full deployment
11. Answer the self-check questions at the end of each file
