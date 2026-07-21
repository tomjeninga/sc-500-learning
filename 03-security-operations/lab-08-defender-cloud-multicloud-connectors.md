# Lab 08: Multicloud Posture with Defender for Cloud AWS and GCP Connectors

## SC-500 Skill Mapping

This lab maps to SC-500 security operations objectives around:

- Extending Defender for Cloud posture management to multicloud environments
- Understanding AWS and GCP connector onboarding in Defender for Cloud
- Distinguishing CSPM from CWPP in multicloud design decisions
- Evaluating cost and permission tradeoffs for AWS and GCP security coverage

---

## Learning Objectives

After completing this lab, you will be able to:

- Connect an AWS account or GCP project to Defender for Cloud
- Explain the difference between Foundational CSPM, Defender CSPM, and Defender for Servers in multicloud scenarios
- Recognize where Azure Arc is automatically involved for AWS and GCP server protection
- Validate connector health and coverage in Defender for Cloud
- Understand the main cost and permission considerations before enabling multicloud plans

---

## Prerequisites

- Azure subscription with Microsoft Defender for Cloud enabled
- Contributor or Owner permissions on the Azure subscription used for the connector
- Access to either:
  - An AWS account, or
  - A GCP project
- Optional but recommended: `03-security-operations/lab-07-defender-cloud-hybrid-arc.md`

---

## Architecture (in words)

Defender for Cloud uses a native multicloud connector to authenticate into AWS or GCP by federated trust. Posture findings flow back into Defender for Cloud. If you also enable Defender for Servers, Azure Arc can be autoprovisioned onto discovered AWS or GCP machines so they can receive deeper server protection.

```text
AWS account / GCP project
          |
          v
Native multicloud connector
          |
          +--> CSPM posture and recommendations
          +--> Optional Defender CSPM features
          +--> Optional Defender for Servers / other CWPP plans
                       |
                       v
             Azure Arc autoprovisioning for machines
```

---

> **Depends on:** `03-security-operations/lab-01-defender-cloud.md`
> **Reused by:** later AKS, containers, Arc, or multicloud SQL coverage if the repo expands further
> **Delete after:** you complete connector validation and no longer need the multicloud environment connected for study

## Part 1: Lock in the CSPM vs CWPP decision model

Before connecting anything, use this mental model:

| Need | Best starting point |
| --- | --- |
| Cross-cloud posture visibility and recommendations | Foundational CSPM or Defender CSPM |
| Advanced posture like attack path and richer analysis | Defender CSPM |
| Server threat protection on AWS/GCP machines | Defender for Servers |
| Container protection on EKS/GKE | Defender for Containers |

**Why this control, not the distractor:**
- Use **CSPM** when the question is about posture, recommendations, standards, or Secure Score
- Use **CWPP plans** when the question is about protecting workloads such as servers, containers, or SQL running in AWS or GCP

---

## Part 2: Connect an AWS account

### Portal path

1. Open **Microsoft Defender for Cloud** -> **Environment settings**
2. Select **Add environment** -> **Amazon Web Services**
3. Configure:
   - Connector name
   - Account type: management account or single account
   - Regions to scan
   - Azure subscription, resource group, and location for the connector resource
4. Choose the Defender plans you want to enable
5. Select a permissions model:
   - **Default access**, or
   - **Least privilege access**
6. Complete the AWS-side deployment by using CloudFormation or Terraform

### AWS-specific study points

- Defender for Cloud uses federated trust and short-lived credentials, not long-lived stored secrets
- If you enable Defender for Servers for AWS EC2, Azure Arc autoprovisioning is recommended
- The AWS Systems Manager agent is part of the onboarding requirements for EC2 server autoprovisioning

### Cost note

For CSPM on AWS, Defender for Cloud performs read-only API calls that can appear in CloudTrail. Those calls do not incur extra AWS charges by themselves, but exporting large CloudTrail volumes to another SIEM can increase ingestion cost.

---

## Part 3: Connect a GCP project

### Portal path

1. Open **Microsoft Defender for Cloud** -> **Environment settings**
2. Select **Add environment** -> **Google Cloud Platform**
3. Configure:
   - Azure subscription, resource group, and location for the connector resource
   - GCP organization or single project scope
   - Scan interval
4. Choose the Defender plans you want to enable
5. Configure access and generate the `gcloud` script
6. Run the script in the GCP environment

### GCP-specific study points

- Defender for Cloud uses workload identity federation and service account impersonation
- Project- or organization-level scope changes what the onboarding script creates
- If autoprovisioning is enabled, Azure Arc and selected extensions can be installed on supported GCP machines automatically

---

## Part 4: Choose the right Defender plans

Use this lab to compare the main options:

| Plan | Multicloud purpose |
| --- | --- |
| Foundational CSPM | Baseline posture, recommendations, secure score visibility |
| Defender CSPM | Advanced posture capabilities such as richer analysis and prioritization |
| Defender for Servers | AWS/GCP machine protection and deeper server security |
| Defender for Containers | EKS and GKE container posture and threat protection |

> Start narrow in a lab. Enable only the plans you are actually validating, because each extra plan can add cost and extra cloud-side permissions.

---

## Part 5: Validate connector health and coverage

### Step 5.1 - Review Environment settings

1. In Defender for Cloud, return to **Environment settings**
2. Confirm the AWS account or GCP project appears
3. Review the **Connectivity status** and open it if issues are shown

### Step 5.2 - Review posture visibility

1. Open the connected environment in Defender for Cloud
2. Review:
   - Recommendations
   - Secure Score contribution
   - Plan coverage

### Step 5.3 - Review server onboarding expectations

If you enabled Defender for Servers:

- Confirm that Azure Arc autoprovisioning is the expected path for AWS/GCP machine coverage
- Note any missing prerequisites such as SSM on AWS or required GCP APIs

---

## Validate

Confirm all of the following:

- An AWS account or GCP project is connected to Defender for Cloud
- You can explain why the connector uses federated trust instead of long-lived secrets
- You can distinguish Foundational CSPM, Defender CSPM, and Defender for Servers
- You can identify where Azure Arc fits into AWS/GCP server protection
- You can explain at least one cost or permission tradeoff for multicloud onboarding

---

## Exam Traps

- **CSPM** is not the same as **Defender for Servers**
- AWS and GCP posture visibility can exist without enabling every workload protection plan
- For AWS and GCP servers, Defender for Cloud still leans on **Azure Arc** for fuller server coverage
- The question might test **permissions model** choices such as default access vs least privilege access
- Multicloud onboarding often uses **federated trust**, not saved cloud credentials or static secrets

---

## Cleanup

1. Remove the AWS or GCP connector if it was created only for lab study
2. Disable any paid Defender plans you enabled for the connected environment
3. Remove cloud-side onboarding artifacts if they were created only for the lab and are no longer needed

---

## References

- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-aws>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/quickstart-onboard-gcp>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/plan-multicloud-security-determine-multicloud-dependencies>
