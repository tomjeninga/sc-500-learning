# Lab 06: AKS, ACR, and Defender for Containers

## SC-500 Skill Mapping

This lab maps to SC-500 secure compute objectives around:

- Implementing security controls for Azure Kubernetes Service (AKS)
- Implementing security controls for Azure Container Registry (ACR)
- Detecting container misconfigurations and runtime risk with Defender for Containers
- Applying managed identity, RBAC, and network restrictions to container platforms

---

## Learning Objectives

After completing this lab, you will be able to:

- Explain the difference between AKS cluster security, registry security, and runtime protection
- Apply core AKS controls such as Azure RBAC, workload identity, private or restricted API access, and network policy
- Apply ACR controls such as RBAC, disabling the admin account, and reducing public exposure
- Enable Defender for Containers and understand what it protects in AKS and ACR
- Validate vulnerability and posture findings for a container platform workload

---

## Prerequisites

- Azure subscription with Contributor permissions
- Optional existing VNet from `lab-01-network-security.md`
- Optional existing Defender for Cloud setup from `03-security-operations/lab-01-defender-cloud.md`
- Basic familiarity with containers, registries, and Kubernetes concepts

---

## Architecture (in words)

Container images are stored in Azure Container Registry. AKS pulls only approved images from ACR. Defender for Containers adds posture and runtime protection across the registry and the cluster. Managed identity or workload identity is preferred over embedded pull secrets or hard-coded credentials.

```text
Developer or pipeline
        |
        v
Azure Container Registry
        |
        v
AKS cluster
        |
        +--> Azure RBAC / Kubernetes RBAC
        +--> Workload identity / managed identity
        +--> Network policy / restricted API access
        |
        v
Defender for Containers
   +--> Registry vulnerability findings
   +--> AKS posture recommendations
   +--> Runtime telemetry and alerts
```

---

> **Depends on:** `03-security-operations/lab-01-defender-cloud.md` if you want Defender for Containers findings in the same subscription view
> **Reused by:** later AI, container, or multicloud Kubernetes follow-up work
> **Delete after:** you finish validating AKS, ACR, and Defender for Containers findings and no longer need the cluster or registry for study

## Part 1: Lock in the AKS security model

Before deploying anything, separate these control layers:

| Layer | What it protects |
| --- | --- |
| Build and image pipeline | What gets packaged and promoted |
| Registry security | What images can be stored and pulled |
| Cluster security | API access, node security, workload boundaries |
| Runtime protection | Active detection of threats and risky behavior |

**Why this control, not the distractor:**
- **ACR** is not runtime protection; it is the image store and access boundary
- **AKS RBAC or Azure RBAC** controls cluster access, not vulnerability scanning
- **Defender for Containers** adds posture and runtime detection; it does not replace base cluster hardening

---

## Part 2: Secure Azure Container Registry

### Step 2.1 - Create or review an ACR

1. Create or open an Azure Container Registry in `rg-sc500-lab`
2. Review the **Access keys** blade
3. Disable the **admin user** unless you have a temporary lab reason to keep it on

### Step 2.2 - Use identity and RBAC

1. Review who can push and pull images
2. Prefer Azure RBAC roles such as:
   - `AcrPull`
   - `AcrPush`
3. Avoid broad Contributor assignments when registry-specific roles are enough

### Step 2.3 - Reduce network exposure

1. Review whether public network access is required
2. If your lab supports it, prefer:
   - Private endpoint, or
   - Restricted network access

### Step 2.4 - Understand registry scanning expectations

Defender for Containers can scan images stored in ACR, but findings are asynchronous rather than instant. New images usually take time to appear in vulnerability results.

---

## Part 3: Secure the AKS cluster baseline

### Step 3.1 - Review cluster access controls

For AKS, review or enable:

- **Azure RBAC for Kubernetes authorization**
- **Microsoft Entra integration**
- **OIDC issuer and workload identity**

### Step 3.2 - Reduce API server exposure

Review the API server exposure model:

- Public endpoint with **authorized IP ranges**, or
- **Private cluster** for the strongest network isolation

### Step 3.3 - Apply workload isolation basics

Review or enable:

- **Network policies** between pods or namespaces
- Avoiding unnecessary privileged containers
- Secret handling that avoids committing credentials into manifests

> For SC-500, the exam usually wants you to choose the control plane that reduces exposure, not just to describe Kubernetes generically.

---

## Part 4: Prefer workload identity and secretless access

### Step 4.1 - Review identity approach

1. Confirm the cluster supports **workload identity**
2. Compare it to older patterns such as stored secrets or broader node identity use

### Step 4.2 - Use secure access to Azure services

For a sample app or design review, prefer:

- Workload identity to access Key Vault, Storage, or SQL
- Avoiding embedded service credentials in pod specs or ConfigMaps

---

## Part 5: Enable Defender for Containers

### Step 5.1 - Turn on the plan

1. Open **Microsoft Defender for Cloud** -> **Environment settings**
2. Select the subscription that contains the AKS cluster
3. Turn on **Containers**
4. Review **Settings** and note the main components:
   - Defender sensor
   - Azure Policy
   - Kubernetes API access
   - Registry access
   - Agentless scanning for machines

### Step 5.2 - Understand what each component gives you

| Component | Why it matters |
| --- | --- |
| Defender sensor | Runtime telemetry and threat detections |
| Azure Policy | Kubernetes posture recommendations |
| Kubernetes API access | Inventory and configuration analysis |
| Registry access | Vulnerability findings tied to images |

### Step 5.3 - Validate findings

1. Review Defender for Cloud recommendations for the cluster
2. Review image vulnerability findings for the ACR images if available
3. Note that results can take hours rather than appearing immediately

---

## Validate

Confirm all of the following:

- The registry admin user is disabled or intentionally justified for temporary lab use
- ACR access is governed with least-privilege Azure RBAC roles
- The AKS cluster uses or plans for Microsoft Entra integration and workload identity
- The API server exposure model is intentionally chosen
- Defender for Containers is enabled and you can explain what each component does

---

## Exam Traps

- **ACR** protects the image supply source, but it is not cluster runtime protection
- **Defender for Containers** runtime protection is available for AKS; image scanning alone is not the full story
- **Workload identity** is usually the best answer when an AKS workload needs Azure resource access
- **Private cluster** or **authorized IP ranges** are about API server exposure, not pod-to-pod traffic

---

## Cleanup

1. Delete the AKS cluster if it was created only for the lab
2. Delete the ACR if it was created only for the lab
3. Disable Defender for Containers if you enabled it only for temporary study use

---

## References

- <https://learn.microsoft.com/en-us/azure/aks/concepts-security>
- <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-enable-plan>
- <https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro>
- <https://learn.microsoft.com/en-us/azure/architecture/guide/container-service-general-considerations>
