# Security Policy

## Reporting a Vulnerability

If you discover a security issue in this repository, please **do not open a public GitHub issue** with sensitive details.

Instead, report it privately by contacting the repository owner through GitHub or by using GitHub's private vulnerability reporting feature if enabled.

Please include:

- A clear description of the issue
- Steps to reproduce
- The affected file(s) or workflow(s)
- Any suggested remediation, if known

## Scope

This repository mainly contains:

- SC-500 study documentation
- hands-on lab instructions
- sample IaC templates (ARM/Bicep)
- GitHub workflow files

Typical security concerns may include:

- accidentally committed secrets
- insecure sample defaults
- unsafe GitHub Actions workflow behavior
- misleading security guidance in labs or templates

## What to Avoid

Please do not include:

- real credentials
- access tokens
- tenant IDs, subscription IDs, or object IDs from production environments
- sensitive screenshots or logs from live systems

## Supported Versions

This repository is maintained on the `main` branch only. Security fixes, if needed, will be applied there.
