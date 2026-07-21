# Domain 4: Data Protection

## Learning Objectives

By completing this domain, you will be able to:

- Configure Azure Storage encryption with Customer-Managed Keys (CMK) via Key Vault
- Implement Private Endpoints and disable public access on storage accounts
- Configure Azure SQL Database with TDE, Entra ID authentication, and Defender for SQL
- Understand Always Encrypted for sensitive column protection
- Configure SQL auditing and data classification
- Understand Microsoft Purview/MIP sensitivity labels and DLP concepts
- Understand how Purview DSPM for AI complements labels and DLP

---

## Domain Overview

Data protection secures data **at rest, in transit, and in use** across Azure storage, databases, and analytics services. This domain also covers the governance and classification of sensitive data.

### SC-500 Exam Weight: ~15–20%

Expect questions on:
- CMK vs PMK: when each is used, how to rotate keys
- Key Vault access policies vs RBAC
- SQL TDE vs Always Encrypted (what each protects against)
- Private Endpoint configuration for storage and SQL
- Defender for SQL alert types
- Microsoft Purview sensitivity labels and DLP policy structure

---

## Labs in This Domain

| Lab | Topic | Est. Time |
|-----|-------|-----------|
| `lab-01-storage-encryption.md` | Storage account CMK + Private Endpoint | 45–60 min |
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
- [SC-500: Secure data and applications](https://learn.microsoft.com/en-us/training/paths/secure-data-applications/)

---

## Start Here

1. Read `study-guide.md` — understand CMK vs PMK, TDE, and DLP concepts
2. Complete `lab-01-storage-encryption.md` — configure CMK and private endpoint
3. Complete `lab-02-database-security.md` — secure SQL database
4. Complete `lab-03-purview-labels-dlp-dspm.md` — compare classification, prevention, and AI exposure discovery
5. Deploy ARM templates for IaC practice
