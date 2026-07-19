# SC-500: Azure Security Engineer Associate Certification Lab

Welcome to your comprehensive learning companion for the **Microsoft Azure SC-500** certification exam!

This repository combines:
- 📚 **Theory-First Learning** - Study guides explaining concepts before building
- 🔧 **Hands-On Labs** - Step-by-step Azure Portal instructions with Infrastructure-as-Code
- 🏗️ **ARM Templates & PowerShell** - Automation scripts to repeat labs efficiently
- 📊 **Real-World Scenarios** - Security challenges based on actual Azure deployments

---

## 📋 What is SC-500?

The **SC-500: Microsoft Certified - Azure Security Engineer Associate** certification validates your expertise in:
- Implementing Azure security controls
- Managing identity and access
- Protecting data and applications
- Operating security infrastructure
- Ensuring governance and compliance

**Exam Format:** 40-60 questions | 120 minutes | Multiple choice, case studies, drag-and-drop

---

## 🎯 How to Use This Repository

### Learning Path (10-15 hours/week recommended)

1. **Start here:** Read `ROADMAP.md` for a week-by-week study plan
2. **Setup:** Complete `AZURE-SETUP.md` to prepare your environment
3. **Learn:** Follow the 5 exam domains in order:
   - `01-identity-governance/` - Start with Entra ID and RBAC basics
   - `02-platform-protection/` - Network and encryption security
   - `03-security-operations/` - Defender and monitoring
   - `04-data-protection/` - Data security and DLP
   - `05-governance-compliance/` - Policies and compliance

### Per Domain Structure

Each domain folder contains:
- **README.md** - Overview of learning objectives
- **study-guide.md** - Detailed theory (READ FIRST)
- **lab-01-*.md, lab-02-*.md** - Step-by-step labs (LEARN BY DOING)
- **templates/** - ARM templates for infrastructure automation
- **scripts/** - PowerShell scripts for setup and configuration

### Learning Approach: Read → Build → Automate

```
1. READ the study guide (understand the concept)
   ↓
2. FOLLOW lab instructions in Azure Portal (hands-on learning)
   ↓
3. USE ARM templates & scripts to repeat automatically (efficiency)
   ↓
4. PRACTICE scenarios and validate your understanding
```

---

## 📚 Repository Structure

```
sc-500-learning/
├── README.md                          # This file
├── ROADMAP.md                         # Week-by-week learning plan
├── AZURE-SETUP.md                     # Azure subscription setup guide
├── 01-identity-governance/
│   ├── README.md
│   ├── study-guide.md
│   ├── lab-01-entra-id-setup.md
│   ├── lab-02-conditional-access.md
│   ├── templates/
│   │   ├── conditional-access-policy.json
│   │   └── rbac-assignments.json
│   └── scripts/
│       ├── setup-entra-id-lab.ps1
│       └── create-test-users.ps1
├── 02-platform-protection/
│   ├── README.md
│   ├── study-guide.md
│   ├── lab-01-network-security.md
│   ├── lab-02-waf-setup.md
│   ├── templates/
│   │   ├── vnet-with-nsg.json
│   │   └── app-gateway-waf.json
│   └── scripts/
│       └── deploy-network-lab.ps1
├── 03-security-operations/
│   ├── README.md
│   ├── study-guide.md
│   ├── lab-01-defender-cloud.md
│   ├── lab-02-sentinel-setup.md
│   └── templates/
│       ├── log-analytics-workspace.json
│       └── sentinel-workspace.json
├── 04-data-protection/
│   ├── README.md
│   ├── study-guide.md
│   ├── lab-01-storage-encryption.md
│   ├── lab-02-database-security.md
│   └── templates/
│       ├── storage-account-encrypted.json
│       └── sql-database-secured.json
├── 05-governance-compliance/
│   ├── README.md
│   ├── study-guide.md
│   ├── lab-01-azure-policy.md
│   ├── lab-02-compliance-assessment.md
│   └── templates/
│       └── azure-policy-definitions.json
├── resources/
│   ├── microsoft-learn-links.md
│   ├── exam-tips.md
│   └── glossary.md
└── scripts/
    └── cleanup-resources.ps1
```

---

## ✅ Prerequisites

Before starting, ensure you have:

- [ ] **Azure Subscription** (Free tier or paid) - See `AZURE-SETUP.md`
- [ ] **PowerShell 7+** or **Azure CLI** for script execution
- [ ] **Visual Studio Code** (optional but recommended)
- [ ] **Azure Storage Explorer** (optional, for data protection labs)
- [ ] **Basic understanding** of Azure fundamentals (VNets, resource groups, etc.)

---

## 🚀 Quick Start

### Step 1: Setup Your Azure Environment
```bash
# Read and follow Azure setup guide
cat AZURE-SETUP.md
```

### Step 2: Start with Identity & Governance (Domain 1)
```bash
cd 01-identity-governance/
# Read study guide first
cat study-guide.md
# Then follow lab 1
cat lab-01-entra-id-setup.md
```

### Step 3: Follow the Learning Path
- Dedicate 2-3 hours per session
- Complete one lab per session
- Review concepts before moving forward
- Take practice exams between domains

---

## 📖 Exam Domains (5 Total)

| Domain | Focus Area | Labs |
|--------|-----------|------|
| **01 - Identity & Governance** | Entra ID, RBAC, PIM, Conditional Access | 2 |
| **02 - Platform Protection** | Network Security, Firewalls, WAF, Encryption | 2 |
| **03 - Security Operations** | Defender for Cloud, Sentinel, Threat Detection | 2 |
| **04 - Data Protection** | Data Classification, DLP, Database Security | 2 |
| **05 - Governance & Compliance** | Azure Policy, Compliance Frameworks | 2 |

**Total Labs:** 10 hands-on labs across all domains

---

## 💡 Learning Tips

1. **Read First, Build Second** - Understanding concepts before implementing prevents confusion
2. **Use Portal First** - Learn how Azure Portal works before automating with templates
3. **Document Your Learning** - Take notes, create your own practice questions
4. **Repeat Labs** - Run cleanup scripts and redo labs to build muscle memory
5. **Connect Concepts** - See how security controls interact (e.g., NSG + WAF + DLP)
6. **Reference Microsoft Learn** - Links provided in each study guide
7. **Ask Copilot** - Use GitHub Copilot Chat to ask questions about security concepts

---

## 🔗 Official Resources

- **Microsoft Learn Path**: [Azure Security Engineer Associate](https://learn.microsoft.com/en-us/training/browse/?resource_type=learning%20path&roles=security-engineer&products=azure)
- **Exam Details**: [SC-500 Exam Page](https://learn.microsoft.com/en-us/credentials/certifications/exams/sc-500)
- **Microsoft Azure Docs**: [Azure Security Documentation](https://learn.microsoft.com/en-us/azure/security/)

---

## 💰 Cost Optimization

- Use **Free Tier resources** where possible
- Deploy labs in **non-production resource groups**
- Use **cleanup scripts** after each lab to prevent unexpected costs
- Monitor **Azure Cost Management** regularly
- See `AZURE-SETUP.md` for cost management tips

---

## 📝 Progress Tracking

Use this checklist to track your progress:

### Domain 1: Identity & Governance
- [ ] Study guide completed
- [ ] Lab 01 - Entra ID Setup completed
- [ ] Lab 02 - Conditional Access completed
- [ ] Practice scenarios completed

### Domain 2: Platform Protection
- [ ] Study guide completed
- [ ] Lab 01 - Network Security completed
- [ ] Lab 02 - WAF Setup completed

### Domain 3: Security Operations
- [ ] Study guide completed
- [ ] Lab 01 - Defender for Cloud completed
- [ ] Lab 02 - Sentinel Setup completed

### Domain 4: Data Protection
- [ ] Study guide completed
- [ ] Lab 01 - Storage Encryption completed
- [ ] Lab 02 - Database Security completed

### Domain 5: Governance & Compliance
- [ ] Study guide completed
- [ ] Lab 01 - Azure Policy completed
- [ ] Lab 02 - Compliance Assessment completed

---

## 🤝 Contributing & Feedback

This is your personal learning lab! Feel free to:
- Add your own notes and insights
- Create additional labs for scenarios you encounter
- Share improvements with the community
- Document your exam journey

---

## 📬 Support

- **Questions about labs?** Check the troubleshooting section in each lab
- **Copilot Chat** - Use GitHub Copilot to ask security questions
- **Microsoft Learn** - Link provided in each domain folder
- **Azure Support** - For Azure-specific issues (free tier has limited support)

---

## 🎓 Ready to Begin?

👉 **Next Step:** Read `ROADMAP.md` for your week-by-week study plan

Good luck on your SC-500 certification journey! 🚀

---

*Last Updated: July 2026*
*Designed for: Cloud Platform Engineers*
*Time Commitment: 10-15 hours/week*
