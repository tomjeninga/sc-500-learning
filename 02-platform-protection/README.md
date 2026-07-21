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

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-network-security.md` | VNet + subnets + NSGs + test VMs | 60–90 min |
| `lab-02-waf-setup.md` | App Gateway v2 + WAF_v2 + OWASP + simulate attacks | 90–120 min |

---

## Templates & Scripts

| File | Purpose |
| ------ | --------- |
| `templates/vnet-with-nsg.json` | ARM template — VNet with subnets and NSG rules |
| `templates/app-gateway-waf.json` | ARM template — Application Gateway v2 with WAF_v2 |
| `scripts/deploy-network-lab.ps1` | Deploys both templates, validates deployment |

---

## Key Microsoft Learn Links

- [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/)
- [Introduction to Azure Firewall](https://learn.microsoft.com/en-us/training/modules/introduction-azure-firewall/)
- [Secure network connectivity on Azure](https://learn.microsoft.com/en-us/training/modules/secure-network-connectivity-azure/)
- [SC-500: Implement platform protection](https://learn.microsoft.com/en-us/training/paths/implement-platform-protection/)

---

## Start Here

1. Read `study-guide.md` — understand the network security controls
1. Complete `lab-01-network-security.md` — build VNet + NSG infrastructure
1. Complete `lab-02-waf-setup.md` — deploy and test WAF
1. Run `scripts/deploy-network-lab.ps1` to automate the full deployment
1. Answer the self-check questions at the end of each file
