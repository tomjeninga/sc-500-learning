# SC-500 Security Glossary

Definitions of key terms for the Microsoft Azure Security Engineer Associate (SC-500) exam.

---

## A

**Access Review**  
A Microsoft Entra ID Governance feature that enables periodic review and attestation of user access to roles, groups, or applications. Reviewers confirm whether users still need their access; auto-apply removes access if not confirmed.

**Always Encrypted**  
An Azure SQL Database feature that encrypts specific columns at the client side. The SQL Server engine never sees the plaintext — only the client application holding the encryption key can read the data. Protects against database administrator (DBA) snooping.

**App Registration**  
The global definition of an application in Microsoft Entra ID. Creates a Service Principal when granted consent. Used for OAuth 2.0, OpenID Connect, and SAML-based authentication.

**Application Security Group (ASG)**  
A network object that groups virtual machines by workload role (e.g., web servers, database servers). Used in NSG rules instead of IP addresses, simplifying rule management at scale.

**ARM Template (Azure Resource Manager template)**  
A JSON file that defines Azure infrastructure as code. Declarative syntax specifying which resources to deploy, their configurations, and dependencies. ARM templates are idempotent — deploying the same template multiple times produces the same result.

**Azure Bastion**  
A fully managed Azure service that provides secure RDP and SSH access to VMs through the Azure Portal over HTTPS. Eliminates the need to expose port 22 or 3389 to the internet.

**Azure DDoS Protection**  
A service protecting Azure resources from Distributed Denial of Service attacks. Available in Basic (free, infrastructure-level) and Standard tiers. Standard provides application-specific policies, adaptive tuning, and attack telemetry.

**Azure Firewall**  
A managed, stateful cloud-native network firewall with built-in high availability. Supports Layer 4 (TCP/UDP) and Layer 7 (FQDN filtering, application rules). Includes threat intelligence-based filtering.

**Azure Policy**  
A service for creating, assigning, and managing rules (policies) that enforce compliance across Azure resources. Effects include Deny, Audit, DeployIfNotExists, and Modify.

---

## B

**Break-Glass Account**  
An emergency-access account with Global Administrator privileges that bypasses Conditional Access policies and MFA requirements. Used when normal admin access is unavailable. Should be monitored with alerts.

**BYOK (Bring Your Own Key)**  
The practice of supplying your own encryption key (via Key Vault) rather than using Microsoft-managed keys. Enables customer-controlled encryption for services like Azure SQL (TDE with CMK) and Azure Storage.

---

## C

**Certificate-Based Authentication (CBA)**  
Phishing-resistant MFA method using X.509 certificates stored on smart cards or virtual smart cards. Meets NIST AAL3 requirements.

**CIS Benchmark (Center for Internet Security)**  
A set of technical hardening guidelines for cloud environments. Microsoft publishes a CIS Microsoft Azure Foundations Benchmark that maps to Azure security configurations.

**Cloud Security Posture Management (CSPM)**  
The practice of continuously evaluating cloud configurations against security best practices and regulatory standards. In Azure, provided by the foundational tier of Defender for Cloud.

**Cloud Workload Protection Platform (CWPP)**  
Runtime protection for cloud workloads (VMs, containers, databases). In Azure, provided by the paid Defender plans (Defender for Servers, Defender for SQL, etc.).

**CMK (Customer-Managed Key)**  
An encryption key stored in Azure Key Vault and managed by the customer (not Microsoft). Services using CMK cannot decrypt data if the key is revoked or deleted. Contrast with PMK.

**Common Event Format (CEF)**  
A standardized log format for security events from third-party network devices (firewalls, IDS/IPS). Sentinel can ingest CEF logs via a syslog forwarder agent.

**Conditional Access**  
A Microsoft Entra ID P1+ feature that enforces access policies based on signals (user, device, location, app, risk). Acts as a policy engine: IF conditions THEN controls (grant/block/session).

---

## D

**DEK (Data Encryption Key)**  
The key that directly encrypts data. In Azure's envelope encryption model, the DEK is wrapped by a Key Encryption Key (KEK). Changing the KEK rotates the DEK wrapper without re-encrypting all underlying data.

**Defender for Cloud**  
Microsoft's unified Cloud Security Posture Management (CSPM) and Cloud Workload Protection Platform (CWPP). Provides Secure Score, security recommendations, and workload-specific threat protection.

**Defender for Servers**  
A Defender for Cloud plan that protects Azure VMs and Arc-enabled servers. Plan 1 includes Microsoft Defender for Endpoint integration and JIT VM access. Plan 2 adds file integrity monitoring and 500 MB log allowance.

**DLP (Data Loss Prevention)**  
Policies that detect and prevent unauthorized sharing or exposure of sensitive information. In Microsoft 365, DLP policies examine Exchange, SharePoint, OneDrive, Teams, and SQL for sensitive information types.

**DNAT (Destination Network Address Translation)**  
An Azure Firewall feature that translates inbound traffic from a public IP/port to a private IP/port. Used to publish internal services to the internet through the firewall.

**DDoS (Distributed Denial of Service)**  
A cyberattack that floods a target with traffic from multiple sources to overwhelm and disable it. Azure DDoS Protection provides always-on monitoring and mitigation.

---

## E

**Eligible Assignment (PIM)**  
A role assignment where the user must actively *activate* the role to use it. Provides just-in-time access to privileged roles. Contrast with Active Assignment (permanently active).

**Entra ID (Microsoft Entra ID)**  
Microsoft's cloud-based identity provider (formerly Azure Active Directory). Provides authentication, authorization, MFA, Conditional Access, PIM, and identity protection for Microsoft 365, Azure, and third-party apps.

**Envelope Encryption**  
A cryptographic technique where data is encrypted with a Data Encryption Key (DEK), and the DEK itself is encrypted with a Key Encryption Key (KEK) stored in Key Vault. Used by Azure storage, SQL, and other services.

---

## F

**FIDO2 (Fast Identity Online 2)**  
A phishing-resistant authentication standard using public-key cryptography. FIDO2 security keys (YubiKey, Windows Hello) replace passwords and provide the strongest available MFA method.

**FIM (File Integrity Monitoring)**  
A Defender for Servers Plan 2 feature that monitors Windows and Linux files, registries, and OS settings for unexpected changes that may indicate a compromise.

---

## G

**Global Administrator**  
The highest-privilege role in Microsoft Entra ID. Can manage all aspects of Entra ID and Microsoft 365 services. Should be assigned to fewer than 5 accounts; all should use PIM and phishing-resistant MFA.

---

## H

**HIPAA (Health Insurance Portability and Accountability Act)**  
US federal law governing the privacy and security of protected health information (PHI). Azure provides a HIPAA Business Associate Agreement (BAA) and a HIPAA compliance standard in Defender for Cloud.

**Hub-Spoke Network Topology**  
Azure's recommended network architecture. A central "hub" VNet contains shared services (Firewall, VPN, Bastion); application "spoke" VNets peer to the hub. Centralizes security and simplifies routing.

---

## I

**Identity Protection**  
A Microsoft Entra ID P2 feature that uses machine learning to detect risky sign-ins and risky users (leaked credentials, impossible travel, etc.). Can enforce MFA or block sign-in via risk-based Conditional Access policies.

**Initiative (Azure Policy)**  
A collection of related policy definitions grouped to achieve a compliance goal. Examples: CIS Microsoft Azure Foundations Benchmark, NIST SP 800-53. Also called a "policy set."

---

## J

**JIT (Just-In-Time) VM Access**  
A Defender for Servers feature that closes management ports (22, 3389) on NSG rules by default and temporarily opens them only for specific users, from specific IPs, for a defined duration. Part of the Zero Trust "assume breach" principle.

**JIT (Just-In-Time) Access in PIM**  
The practice of activating privileged roles only when needed and for a limited time. Reduces the window of exposure if credentials are compromised.

---

## K

**KEK (Key Encryption Key)**  
The master key that wraps the Data Encryption Key (DEK). Stored in Azure Key Vault. The KEK never leaves Key Vault — Azure services use Key Vault's wrap/unwrap operations.

**Key Vault**  
Azure's managed hardware security module (HSM)-backed service for storing cryptographic keys, secrets, and certificates. Provides access control (RBAC or access policies), logging, and soft-delete/purge protection.

**KQL (Kusto Query Language)**  
The query language for Azure Log Analytics, Microsoft Sentinel, and Azure Data Explorer. Used to query and analyze security log data. Key operators: `where`, `summarize`, `project`, `extend`, `join`, `ago()`.

---

## L

**Log Analytics Workspace**  
The data store underlying Microsoft Sentinel and Azure Monitor. Stores log data in tables (AzureActivity, SecurityEvent, SigninLogs, etc.). Queried using KQL.

**Lateral Movement**  
A cyberattack technique where an attacker moves from one compromised system to adjacent systems within the same network. Network segmentation with NSGs and ASGs limits lateral movement.

---

## M

**Managed Identity**  
An Entra ID identity automatically managed by Azure for an Azure resource (VM, App Service, Function, etc.). Eliminates the need to store credentials in code. Two types: System-assigned (tied to resource lifecycle) and User-assigned (standalone resource).

**Management Group**  
An Azure container above subscriptions that enables policy, RBAC, and governance management across multiple subscriptions. Up to 6 levels of management groups can be nested under the Tenant Root Group.

**MCSB (Microsoft Cloud Security Benchmark)**  
Microsoft's own security framework for Azure, replacing the former Azure Security Benchmark. Provides control families (NS, IM, PA, DP, AM, LT, IR, VA) mapped to Azure services and configurations.

**MFA (Multi-Factor Authentication)**  
Authentication using two or more factors: something you know (password), something you have (authenticator app, hardware token), or something you are (biometrics). Required for all privileged accounts.

**MIP (Microsoft Information Protection)**  
Part of Microsoft Purview. Provides sensitivity labels, data classification, and encryption for files, emails, and database columns.

---

## N

**Named Location (Conditional Access)**  
A defined IP range or country used in Conditional Access conditions. Trusted named locations can be used to bypass or modify policy enforcement for known-safe networks.

**NSG (Network Security Group)**  
A stateful Layer 4 firewall attached to subnets or network interfaces. Contains inbound and outbound rules with priority, source, destination, port, and allow/deny. Evaluated by priority (lower number = higher priority).

**NIST SP 800-53**  
US National Institute of Standards and Technology Special Publication 800-53. A comprehensive security and privacy controls catalog used by US federal agencies and contractors.

---

## O

**OWASP (Open Web Application Security Project)**  
A non-profit foundation that publishes the OWASP Top 10 — a list of the most critical web application security risks (SQL injection, XSS, broken authentication, etc.). Azure WAF uses OWASP rule sets to block these attacks.

---

## P

**PCI-DSS (Payment Card Industry Data Security Standard)**  
A security standard for organizations that handle credit card data. Azure provides a PCI-DSS compliance standard in Defender for Cloud.

**PIM (Privileged Identity Management)**  
A Microsoft Entra ID P2 feature that manages just-in-time access to privileged roles. Requires MFA and justification for role activation; supports approval workflows and access reviews.

**PMK (Platform-Managed Key)**  
An encryption key generated and managed by Microsoft. Default encryption model for all Azure storage. Microsoft cannot use PMK keys to decrypt customer data in production.

**Private Endpoint**  
A network interface resource that uses a private IP from your VNet to connect to an Azure PaaS service (Storage, SQL, Key Vault, etc.). Enables fully private access without internet exposure.

**Purge Protection (Key Vault)**  
A Key Vault property that prevents permanent deletion of the vault, keys, secrets, or certificates during the soft-delete retention period. Even subscription administrators cannot purge. Essential for protecting CMK keys.

---

## R

**RBAC (Role-Based Access Control)**  
An authorization system for Azure resources that grants permissions based on role assignments. Three elements: Security principal + Role definition + Scope. Distinct from Entra ID directory roles.

**Remediation Task (Azure Policy)**  
An action that triggers a policy's DeployIfNotExists or Modify effects to fix existing non-compliant resources. Required when policies are assigned after resources already exist.

**Report-Only Mode (Conditional Access)**  
A Conditional Access policy evaluation mode that logs the policy outcome but does NOT enforce it. Used for testing the impact of a new policy before enabling full enforcement.

---

## S

**SAS (Shared Access Signature)**  
A URI-based token granting limited access to Azure Storage resources. User Delegation SAS is signed with an Entra ID credential and is preferred over Account SAS (signed with storage account key).

**Secure Score**  
A Defender for Cloud metric (percentage) representing how well your Azure environment aligns with security best practices. Improved by completing security recommendations.

**Security Default**  
Free Entra ID feature that enforces MFA for all users, blocks legacy authentication, and protects privileged accounts. Mutually exclusive with Conditional Access — you cannot have both enabled.

**Sensitivity Label (MIP)**  
A classification label (Public, Internal, Confidential, Highly Confidential) applied to files, emails, or database columns. Can trigger encryption, visual markings, and DLP policies.

**Service Endpoint**  
A VNet feature that routes traffic to Azure PaaS services over the Azure backbone network, using the service's public endpoint IP. Cheaper than Private Endpoints but does not remove the service's public IP.

**Service Principal**  
The identity of an application or automated service in Entra ID. Created when an app registration is granted consent in a tenant. Has its own credentials (client secret or certificate) or uses Managed Identity.

**Sentinel (Microsoft Sentinel)**  
Microsoft's cloud-native SIEM (Security Information and Event Management) and SOAR (Security Orchestration, Automation, and Response) solution. Runs on Log Analytics workspace. Ingests data via connectors; detects threats via analytics rules.

**SIEM (Security Information and Event Management)**  
A system that collects, aggregates, and analyzes security events from across an environment to detect threats. Microsoft Sentinel is Azure's SIEM.

**SOAR (Security Orchestration, Automation, and Response)**  
A capability that automates security response actions (notify team, block IP, disable user) triggered by security alerts. In Azure, implemented through Sentinel playbooks (Logic Apps) and automation rules.

**Soft Delete (Key Vault)**  
A Key Vault property that retains deleted keys, secrets, and certificates for a configurable period (7–90 days) before permanent deletion. Enabled by default for all new Key Vaults.

---

## T

**TDE (Transparent Data Encryption)**  
Azure SQL Database feature that encrypts database files, backups, and log files at rest using AES-256. Enabled by default on all Azure SQL databases. Transparent to applications — no code changes required.

**Threat Intelligence (Sentinel)**  
Data feeds of known malicious IP addresses, domains, file hashes, and other Indicators of Compromise (IoCs). Sentinel can ingest threat intelligence via connectors to automatically enrich incidents.

---

## U

**UEBA (User and Entity Behavior Analytics)**  
Behavioral analytics that establishes a baseline of normal activity for users and entities (devices, services) and alerts on deviations. Available in Microsoft Sentinel and Defender for Cloud.

---

## V

**VNet (Virtual Network)**  
An isolated, software-defined network in Azure. VNets are the foundation of network security — resources in different VNets cannot communicate without explicit peering or VPN.

**Vulnerability Assessment (Defender for SQL)**  
A Defender for SQL feature that scans database configurations for security weaknesses (missing encryption, excessive permissions, etc.). Provides pass/fail results and remediation guidance.

---

## W

**WAF (Web Application Firewall)**  
An application-layer firewall that filters HTTP/S traffic to protect web applications from attacks like SQL injection, XSS, and path traversal. In Azure: WAF on Application Gateway, Azure Front Door, or Azure CDN.

---

## X

**XDR (Extended Detection and Response)**  
A security approach that integrates detection and response across endpoints, email, identity, cloud, and network. Microsoft Defender XDR unifies Microsoft 365 Defender products. Sentinel integrates with Defender XDR.

**XSS (Cross-Site Scripting)**  
A web vulnerability where attackers inject malicious scripts into web pages viewed by other users. Protected by WAF OWASP ruleset.

---

## Z

**Zero Trust**  
A security model based on three principles: (1) Verify explicitly — always authenticate and authorize; (2) Use least privilege access — JIT, just-enough-access; (3) Assume breach — minimize blast radius, monitor everything. Microsoft Entra ID, Defender, and Sentinel together implement Zero Trust for Azure.
