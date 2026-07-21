---
description: "Use when working in this SC-500 learning repository. Applies to study guides, labs, KQL notes, ARM/Bicep templates, and any Microsoft security content generation for Entra ID, Key Vault, Defender for Cloud, Sentinel, Purview, Microsoft Foundry, AI Gateway, and Entra Agent ID."
applyTo: ["**/*.md", "**/*.bicep", "**/*.json", "**/*.ps1"]
---

# SC-500 learning repository conventions

## Purpose

This repository is a personal SC-500 study companion for Tom Jeninga. All generated content must help him pass **Microsoft Certified: Cloud and AI Security Engineer Associate** and **Exam SC-500: Implementing End-to-End Security Controls for Cloud and AI Workloads**.

## Anchor to the official study guide

- Master source: <https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500>
- Every new lab, study guide section, or note must map to one SC-500 skill bullet from `README.md`.
- Do not add AZ-500-only content unless it also appears in the SC-500 study guide.

## Content style

- Prefer short paragraphs, tables, and checklists over long prose.
- Use "why this control, not the distractors" framing for exam traps.
- Include a **Validate** step for every hands-on procedure (portal check, KQL, Defender for Cloud recommendation, or log evidence).
- Always link Microsoft Learn or Microsoft Docs pages, not third-party sources.

## Security defaults for any sample code, ARM, or Bicep

- Use **Managed Identity** for Azure resource-to-resource auth. Never hardcode keys, secrets, or connection strings.
- Store secrets in **Azure Key Vault**; reference via Key Vault references or managed identity access.
- Enable **soft delete and purge protection** for Key Vault. Do not disable them in samples.
- Prefer **RBAC** over Key Vault access policies.
- Use **private endpoints** and disable public network access where the service supports it.
- Enable **diagnostic settings** to Log Analytics for the resource so Defender/Sentinel can observe it.
- Use **latest stable API version** for ARM/Bicep.

## Lab document template

Each new lab file should follow this structure:

1. **SC-500 skill mapping** - which official bullets it covers
1. **Learning objectives**
1. **Prerequisites**
1. **Architecture (in words)**
1. **Steps** (Portal + CLI/PowerShell/Bicep alternatives)
1. **Validate** (how to prove the control works)
1. **Exam traps**
1. **Cleanup**
1. **References** (Microsoft Learn/Docs URLs)

## KQL conventions

- Prefer `TimeGenerated > ago(...)` filters early in the query for performance.
- Project the fields the analyst actually needs.
- Use `SigninLogs`, `AuditLogs`, `AzureActivity`, `SecurityAlert`, `SecurityRecommendation`, and `DeviceLogonEvents` as the primary tables where appropriate.
- Add a one-line comment explaining what the query answers in exam terms.

## Do not

- Do not add practice-exam questions copied from third-party dumps.
- Do not include tenant IDs, subscription IDs, or object IDs from real environments.
- Do not recommend disabling MFA, purge protection, or diagnostic logging in a lab.
