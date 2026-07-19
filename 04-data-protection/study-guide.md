# Domain 4 Study Guide: Data Protection

## Learning Objectives (SC-500 Aligned)

After reading this guide, you will understand:

- Encryption at rest: PMK vs CMK, Key Vault integration, key rotation
- Azure Key Vault: secrets, keys, certificates, access control models
- Azure Storage: encryption, private endpoints, shared access signatures (SAS)
- Azure SQL: TDE, Always Encrypted, Entra ID auth, auditing, data classification
- Microsoft Purview and MIP: sensitivity labels, DLP policies
- Defender for SQL: threat detection and vulnerability assessment

---

## 1. Encryption at Rest: PMK vs CMK

### Platform-Managed Keys (PMK)

By default, Azure encrypts all data at rest using **Platform-Managed Keys (PMK)**:
- Microsoft generates and manages the keys
- Keys are stored in Microsoft-managed key stores
- Transparent to users — no configuration needed
- Satisfies most compliance requirements (ISO 27001, SOC 2, etc.)

### Customer-Managed Keys (CMK)

Organizations with specific compliance needs (HIPAA Business Associate Agreement, FedRAMP High, PCI-DSS) may require **Customer-Managed Keys**:

- **You** generate and store the key in Azure Key Vault (or Key Vault Managed HSM)
- The Azure service encrypts data using a **Data Encryption Key (DEK)**
- The DEK is wrapped (encrypted) using your **Key Encryption Key (KEK)** in Key Vault
- To decrypt data, Azure must unwrap the DEK using your key
- If you revoke or delete the key → data becomes inaccessible

> **Real-world context for platform engineers:** If you store EU customer PII in Azure SQL and your DPA requires you to prove that Microsoft cannot access the encryption key, you configure CMK. The key lives in your Key Vault (or HSM), and only your service principal has permission to use it.

### Key Rotation

Both PMK and CMK support key rotation:
- **PMK:** Microsoft rotates automatically
- **CMK:** You can configure **automatic key rotation** in Key Vault or rotate manually

After rotation, Azure re-encrypts the DEK with the new key version. Data is **not re-encrypted** — only the DEK wrapper is updated.

### CMK Support Matrix

| Service | CMK Support |
|---------|------------|
| Azure Storage (Blob, Files, Queues, Tables) | ✅ Yes |
| Azure SQL Database | ✅ Yes (via TDE + CMK) |
| Azure Disk Encryption (VM disks) | ✅ Yes |
| Azure Key Vault | ✅ Yes (for Managed HSM) |
| Azure Cosmos DB | ✅ Yes |
| Azure Backup | ✅ Yes |

---

## 2. Azure Key Vault

### What is Key Vault?

Azure Key Vault is a cloud-hosted **key management service** and **secrets store**. It provides:

| Object Type | Description | Examples |
|-------------|-------------|---------|
| **Keys** | Cryptographic keys (RSA, EC) | CMK for storage encryption, TLS certificate private key |
| **Secrets** | Arbitrary sensitive values | Database connection strings, API keys, passwords |
| **Certificates** | X.509 certificates with private keys | TLS certs for App Service, App Gateway |

### Key Vault Access Control Models

**Legacy: Access Policies**
- Configured at the Key Vault level
- Grants specific permissions (Get, List, Encrypt, Decrypt, etc.) to a principal
- Simple but doesn't support Azure RBAC inheritance

**Modern: Azure RBAC**
- Uses Azure role assignments on Key Vault or individual objects
- Supports Management Group/subscription/resource group scope inheritance
- Recommended for new deployments

| RBAC Role | Permissions |
|-----------|-------------|
| Key Vault Administrator | Full management + data access |
| Key Vault Secrets Officer | Create/delete secrets |
| Key Vault Secrets User | Read secrets |
| Key Vault Crypto Officer | Create/delete keys |
| Key Vault Crypto User | Sign/verify with keys |
| Key Vault Reader | Read metadata only |

### Soft Delete and Purge Protection

| Feature | Description | Recommendation |
|---------|-------------|----------------|
| **Soft Delete** | Deleted objects go to a recovery state for N days | Always enable (on by default) |
| **Purge Protection** | Prevents permanent deletion during soft-delete period | Enable for production CMK vaults |

> **Exam tip:** With Purge Protection enabled, even subscription owners cannot permanently delete a Key Vault or its secrets during the soft-delete retention period. This protects against accidental or malicious key deletion.

---

## 3. Azure Storage Security

### Storage Account Security Controls

| Control | Purpose |
|---------|---------|
| **Require HTTPS** (secure transfer) | Enforces TLS for all storage access |
| **Private Endpoint** | Removes public internet access |
| **Network rules** | IP-based allow/deny for storage access |
| **Shared Access Signature (SAS)** | Time-limited, scoped access tokens |
| **Entra ID authentication** | Role-based access (Storage Blob Data Reader/Contributor) |
| **CMK encryption** | Customer-managed encryption key |
| **Immutable storage** | WORM (write-once-read-many) for compliance |
| **Defender for Storage** | Threat detection, malware scanning |

### Private Endpoint vs Network Rules

| Approach | Public IP disabled? | DNS required? | Cost |
|----------|--------------------|--------------|----|
| Private Endpoint | ✅ Yes (optional) | ✅ Private DNS zone | ~$7/month |
| Network rules (IP firewall) | ❌ No | ❌ No | Free |
| Service Endpoint | ❌ No | ❌ No | Free |

For maximum security, use **Private Endpoint** and **disable public network access**.

### Shared Access Signatures (SAS)

SAS tokens provide delegated access without sharing account keys:

| SAS Type | Description |
|----------|-------------|
| **Account SAS** | Grants access to multiple services (Blob, Table, Queue, File) |
| **Service SAS** | Grants access to a single service |
| **User delegation SAS** | Signed with Entra ID credentials — more secure than account keys |

Best practice: Use **User Delegation SAS** signed by an Entra ID identity. Avoid using account keys directly.

---

## 4. Azure SQL Database Security

### Transparent Data Encryption (TDE)

TDE encrypts the SQL database, log files, and backups at rest:
- Enabled by default for all new Azure SQL databases
- Uses AES-256 encryption
- Protects against offline physical storage attacks
- Transparent to the application — no code changes needed

**TDE with CMK:**
- Instead of Microsoft-managed key (PMK), you bring your own key from Key Vault
- The SQL server's managed identity accesses the Key Vault key
- Also called "Bring Your Own Key (BYOK)" for SQL TDE

### Always Encrypted

Always Encrypted protects **specific columns** at the client side:

| Feature | TDE | Always Encrypted |
|---------|-----|-----------------|
| Who can see plaintext | SQL Server | Only client app |
| Database admin can see? | Yes | **No** |
| Encryption location | At rest (storage) | In client application |
| Protects against | Backup theft, disk theft | DBA snooping, cloud provider access |
| Performance impact | Minimal | Moderate (per column) |

> **Exam tip:** Always Encrypted means **the database engine never sees the plaintext** for those columns. A DBA with full SQL access cannot read encrypted columns without the client-side key.

### Entra ID Authentication for SQL

Instead of SQL logins (username/password), Entra ID authentication uses:
- **Managed identities** for applications (no credentials in code)
- **User accounts** for human access (supports MFA and Conditional Access)
- **Service principals** for automated processes

**Best practice:** Disable SQL authentication entirely for production. Use Entra-only authentication.

### SQL Auditing

SQL Auditing captures:
- Database logins/logouts
- SELECT, INSERT, UPDATE, DELETE operations
- Schema changes
- Failed login attempts

Audit logs can be sent to:
- Storage account
- Log Analytics workspace (→ Sentinel)
- Event Hub

### SQL Vulnerability Assessment

Part of Defender for SQL:
- Scans database for misconfigurations (e.g., excessive permissions, missing encryption)
- Reports findings as pass/fail
- Tracks changes between scans (baseline comparison)
- Available in Azure Portal and Defender for Cloud

---

## 5. Microsoft Purview and Data Classification

### Microsoft Purview (formerly Azure Purview)

Microsoft Purview is a unified data governance service for:
- Data catalog: discover and classify data across Azure, on-prem, and multi-cloud
- Sensitivity labels: classify data with labels (Public, Internal, Confidential, Highly Confidential)
- Data map: visualize data lineage

### Microsoft Information Protection (MIP)

MIP sensitivity labels can be applied to:
- **Files** (Office documents, PDFs, emails)
- **Emails** in Outlook
- **Database columns** in SQL

Labels can trigger:
- Visual markings (headers/footers/watermarks)
- Encryption (restrict who can open the file)
- Content marking
- Auto-labeling based on sensitive information types

### Data Loss Prevention (DLP) Policies

DLP policies detect and prevent the sharing of sensitive information:

**Components:**
- **Sensitive information types** (SITs): Pre-built patterns for credit cards, SSNs, passport numbers, etc.
- **Conditions:** Where to look (Exchange, SharePoint, OneDrive, Teams, SQL, etc.)
- **Actions:** Notify user, block, generate alert, restrict sharing

**Common DLP scenarios:**
- Block emails containing 10+ credit card numbers
- Alert when documents with "Confidential" label are shared externally
- Block downloading files with patient health information to unmanaged devices

---

## Comparison: Encryption Features

| Feature | Protects Against | Key Owner | Code Changes? |
|---------|-----------------|-----------|---------------|
| PMK (default) | Physical storage theft | Microsoft | No |
| CMK (Key Vault) | Physical + cloud provider access | Customer | No |
| TDE (SQL) | Database file/backup theft | Microsoft or Customer | No |
| Always Encrypted | Database admin access | Application/customer | Yes (client-side driver) |
| Azure Disk Encryption | VM disk theft | Customer (Key Vault) | No |

---

## Self-Check Questions

1. Your organization's CISO requires that Microsoft cannot technically access the encryption key used for Azure SQL. What technology and configuration do you implement?

2. What is the difference between TDE and Always Encrypted? Which one protects against a malicious database administrator?

3. A developer committed an Azure Storage account key to a public GitHub repository. What are your immediate remediation steps?

4. A storage account with a Private Endpoint still receives traffic from the public internet. What additional step must you take?

5. What Key Vault property prevents permanent deletion of keys even by subscription admins?

6. Your application connects to Azure SQL using a managed identity. What steps are required to configure this, and what Azure SQL feature do you use?

7. What is a User Delegation SAS token, and why is it more secure than an Account SAS?

---

## Microsoft Learn Resources

- [SC-500: Secure data and applications](https://learn.microsoft.com/en-us/training/paths/secure-data-applications/)
- [Configure and manage Azure Key Vault](https://learn.microsoft.com/en-us/training/modules/configure-and-manage-azure-key-vault/)
- [Secure your Azure SQL Database](https://learn.microsoft.com/en-us/training/modules/secure-your-azure-sql-database/)
- [Protect data with MIP sensitivity labels](https://learn.microsoft.com/en-us/training/modules/m365-compliance-information-protect-information/)
- [Azure Storage security overview](https://learn.microsoft.com/en-us/azure/storage/blobs/security-recommendations)
