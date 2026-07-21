# Module 4: Data Protection

## Learning Objectives

By completing this module, you will be able to:

- Configure Azure Storage encryption with Customer-Managed Keys (CMK) via Key Vault
- Implement Private Endpoints and disable public access on storage accounts
- Configure Azure SQL Database with TDE, Entra ID authentication, and Defender for SQL
- Understand Always Encrypted for sensitive column protection
- Configure SQL auditing and data classification
- Understand Microsoft Purview/MIP sensitivity labels and DLP concepts
- Understand how Purview DSPM for AI complements labels and DLP

---

## Module Overview

Data protection secures data **at rest, in transit, and in use** across Azure storage, databases, and analytics services. This module also covers the governance and classification of sensitive data.

### Mapped SC-500 Skill Areas

This module primarily maps to **Secure storage, databases, and networking (25-30%)** and also contributes Key Vault coverage used in **Manage identity, access, and governance (20-25%)**. Expect questions on:
- CMK vs PMK: when each is used, how to rotate keys
- Key Vault access policies vs RBAC
- SQL TDE vs Always Encrypted (what each protects against)
- Private Endpoint configuration for storage and SQL
- Defender for SQL alert types
- Microsoft Purview sensitivity labels and DLP policy structure

---

## Labs in This Module

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-storage-encryption.md` | Storage account CMK + Private Endpoint + Defender for Storage baseline | 45–60 min |
| `lab-02-database-security.md` | SQL with TDE + Entra auth + Defender for SQL | 60–90 min |
| `lab-03-purview-labels-dlp-dspm.md` | Labels + DLP + DSPM for AI | 60–90 min |

---

## Templates & Scripts

| File | Purpose |
|------|---------|
| `templates/storage-account-encrypted.json` | ARM template — Storage account with CMK and private endpoint |
| `templates/sql-database-secured.json` | ARM template — SQL server + database with TDE and Entra auth |

---

## Key Microsoft Learn Links

- [Configure Azure Key Vault](https://learn.microsoft.com/en-us/training/modules/configure-and-manage-azure-key-vault/)
- [Secure Azure Storage](https://learn.microsoft.com/en-us/training/modules/secure-azure-storage-account/)
- [Secure your Azure SQL Database](https://learn.microsoft.com/en-us/training/modules/secure-your-azure-sql-database/)
- [Secure your cloud data in Azure](https://learn.microsoft.com/en-us/training/paths/secure-your-cloud-data/)

---

## Start Here

1. Read `study-guide.md` — understand CMK vs PMK, TDE, and DLP concepts
2. Complete `lab-01-storage-encryption.md` — configure CMK, private endpoint, and a small Defender for Storage baseline
3. Complete `lab-02-database-security.md` — secure SQL database
4. Complete `lab-03-purview-labels-dlp-dspm.md` — compare classification, prevention, and AI exposure discovery
5. Deploy ARM templates for IaC practice
