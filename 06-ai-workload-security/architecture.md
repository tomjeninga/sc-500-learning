# AI Security Stack - Architecture Diagrams

Reference architecture for the SC-500 **Secure compute (AI)** skill area.
The stack flows: **Data → Identity → Network → Gateway → Model → Posture**.

Each layer maps to specific SC-500 exam skills - see the tables below each
diagram for the mapping.

---

## 1. Layered stack view

```mermaid
flowchart TB
    subgraph Data["🗄️ 1. Data layer"]
        DS1[SharePoint / OneDrive]
        DS2[Azure SQL / Cosmos DB]
        DS3[ADLS Gen2 / Blob]
        DS4[Line-of-business apps]
    end

    subgraph Identity["🆔 2. Identity layer"]
        ID1[Entra ID users + groups]
        ID2[Managed Identities]
        ID3[Entra Agent ID]
        ID4[Conditional Access]
        ID5[PIM]
    end

    subgraph Network["🌐 3. Network layer"]
        N1[VNet + Private Endpoints]
        N2[Azure Firewall / NSGs]
        N3[Private DNS zones]
    end

    subgraph Gateway["🚦 4. AI Gateway (APIM)"]
        G1[Token rate limit policy]
        G2[Content Safety filter]
        G3[Prompt shield / jailbreak]
        G4[Semantic cache]
        G5[Backend load balancer]
    end

    subgraph Model["🧠 5. Model layer"]
        M1[Azure AI Foundry hub]
        M2[Model deployments]
        M3[Foundry content filters + guardrails]
        M4[Grounding data via AI Search]
    end

    subgraph Posture["📊 6. Posture + Detection layer"]
        P1[Defender for AI Service]
        P2[Purview DSPM for AI]
        P3[Defender XDR - blast radius]
        P4[Data and AI security dashboard]
        P5[Sentinel + Security Copilot]
    end

    Data --> Identity --> Network --> Gateway --> Model
    Model --> Posture
    Data -.->|classifies + labels| P2
    Identity -.->|audit logs| P5
    Gateway -.->|alerts| P1
    Model -.->|prompts/responses| P1
    Model -.->|DLP + labels| P2
```

### Skill mapping

| Layer | SC-500 skill bullet | Where in this repo |
| --- | --- | --- |
| Data | "Implement data protection for AI" | `04-data-protection/`, `06-ai-workload-security/lab-02-purview-dspm-copilot.md` |
| Identity | "Configure Entra Agent ID with Conditional Access" | `06-ai-workload-security/lab-03-entra-agent-id.md` |
| Network | "Secure endpoints for AI workloads with Private Link" | `02-platform-protection/`, `04-data-protection/lab-02-storage-security.md` |
| Gateway | "Implement AI Gateway in APIM for Azure AI Foundry" | `06-ai-workload-security/lab-01-ai-gateway.md` |
| Model | "Implement guardrails in Azure AI Foundry" | `06-ai-workload-security/study-guide.md` |
| Posture | "Configure Defender for AI Service"; "Purview DSPM for AI" | `06-ai-workload-security/lab-04-defender-for-ai.md`, `lab-02-purview-dspm-copilot.md` |

---

## 2. Request-time sequence (user → model → posture)

```mermaid
sequenceDiagram
    autonumber
    participant U as User / Client app
    participant CA as Conditional Access
    participant APIM as AI Gateway (APIM)
    participant CS as Content Safety
    participant AF as Azure AI Foundry model
    participant DAI as Defender for AI Service
    participant PDS as Purview DSPM for AI

    U->>CA: Auth request (Entra ID / Agent ID)
    CA-->>U: Access token (MFA, device compliance, session risk OK)
    U->>APIM: Prompt + bearer token
    APIM->>APIM: validate-jwt policy
    APIM->>APIM: token-limit policy (per subscription-key)
    APIM->>CS: Screen prompt (jailbreak, harmful content, prompt injection)
    CS-->>APIM: Verdict
    alt Prompt blocked
        APIM-->>U: 403 with policy reason
        APIM->>DAI: Log block event
    else Prompt allowed
        APIM->>AF: Forward to Foundry backend (with managed identity)
        AF->>AF: Foundry content filter (input + output)
        AF-->>APIM: Model response
        APIM->>CS: Screen response
        CS-->>APIM: Verdict
        APIM-->>U: Response (or redacted)
    end

    par Async observability
        APIM->>DAI: Diagnostic + prompt telemetry
        AF->>DAI: Model telemetry (jailbreak, data leak signals)
        AF->>PDS: Prompts + responses for classification/labeling
    end
```

Exam trap watch-list encoded in this flow:

- **Token issuance** happens at **Entra ID**, not at APIM. APIM only **validates** the JWT.
- **Content Safety** enforces at **two** places (APIM + Foundry). If a question asks where to block a jailbreak prompt **before** it reaches the model, the answer is **APIM AI Gateway with Content Safety policy**.
- **Defender for AI Service** is a **detection** control (alerts), not a **prevention** control.
- **Purview DSPM for AI** is about **data visibility and DLP for prompts**, not about blocking traffic.

---

## 3. Trust boundaries and control ownership

```mermaid
flowchart LR
    subgraph EndUser["👤 End-user boundary"]
        User[User / client]
    end

    subgraph Perimeter["🛡️ Perimeter boundary\n(Identity + Network)"]
        Entra[Entra ID + CA + PIM]
        APIM2[APIM AI Gateway]
        FW[Azure Firewall / WAF]
    end

    subgraph Platform["🏗️ Platform boundary\n(compute + model)"]
        Foundry[AI Foundry + models]
        Guard[Foundry guardrails]
        MI[Managed Identity to data]
    end

    subgraph Data2["🔐 Data boundary"]
        KV[Key Vault CMK]
        Store[Storage / SQL private endpoint]
        Purview[Purview labels + DLP]
    end

    subgraph Ops["🔎 Ops boundary\n(SOC + posture)"]
        Defender[Defender for AI + XDR]
        Sentinel[Sentinel + Security Copilot]
        MDC[Defender for Cloud posture]
    end

    User -->|MFA| Entra
    Entra -->|token| APIM2
    APIM2 -->|MI| Foundry
    Foundry --> Guard
    Foundry -->|MI| Store
    Store --> KV
    Store --> Purview

    APIM2 -. logs .-> Sentinel
    Foundry -. logs .-> Defender
    Store -. alerts .-> Defender
    Defender -. incidents .-> Sentinel
    Sentinel -. posture drift .-> MDC
```

Ownership cheat-sheet:

| Boundary | Who owns it | Primary control |
| --- | --- | --- |
| End-user | User + IT | MFA, device compliance |
| Perimeter | Identity + Network team | Entra ID CA, APIM AI Gateway, WAF |
| Platform | AI/App team | Foundry guardrails, managed identity |
| Data | Data team + Compliance | CMK, private endpoints, Purview labels |
| Ops | SOC | Defender XDR, Sentinel, Security Copilot |

---

## How to use these diagrams while studying

- Print the **layered stack view** and keep it beside you during labs 01-04 in `06-ai-workload-security/`.
- Use the **sequence diagram** as your mental model when a question describes an "AI request flow" - trace it top to bottom to locate the control being asked about.
- Use the **trust boundary diagram** when a question is about **"who owns the control"** or **shared responsibility** for an AI workload.
