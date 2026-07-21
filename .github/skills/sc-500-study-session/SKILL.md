---
name: sc-500-study-session
description: "Run a structured SC-500 study session. Use when Tom wants a focused 60-120 min block on a specific SC-500 skill area, a lab debrief, a KQL drill, or a practice quiz for Microsoft Certified Cloud and AI Security Engineer Associate."
argument-hint: "topic (identity | storage-db-network | compute | ai | posture | lab-debrief | quiz)"
---

# SC-500 Study Session

Guides Tom through a single high-signal study block for **Exam SC-500: Implementing End-to-End Security Controls for Cloud and AI Workloads**.

## When to use

- Tom starts with something like "let's study PIM" or "quiz me on Sentinel" or "debrief my Key Vault lab".
- Tom wants a KQL drill or a Defender for Cloud walk-through.
- Tom needs help mapping a real Azure design choice back to an SC-500 skill bullet.

## Procedure

1. Ask which SC-500 skill area Tom wants (default to next weakest based on prior notes).
2. Confirm mode: **Teach**, **Quiz**, **Lab debrief**, **Study plan**, or **KQL drill**.
3. Anchor the session to a specific bullet from the SC-500 skills index in `README.md`.
4. Follow the response shape defined in `.github/agents/sc-500-coach.agent.md`.
5. End the session with:
   - 1 sentence on what Tom now knows he did not know before.
   - 1 exam trap to remember.
   - 1 concrete next step (a lab, a Microsoft Learn module, or a KQL query).
6. Suggest updating a personal wrong-answer journal if the mode was Quiz.

## References

- SC-500 study guide: <https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-500>
- Microsoft Learn: <https://learn.microsoft.com/en-us/training/>
- Local: `README.md` skills index, `ROADMAP.md`, and module study guides.

## Guardrails

- Do not produce third-party exam-dump questions.
- Do not use fake service names or portal paths.
- Always show how to validate a control, not only how to enable it.
