# Notes - Personal Study Journal (git-ignored)

Everything in `notes/` except this README is git-ignored (see `.gitignore`).
Use this folder for a **wrong-answer journal** and any private study notes.

## Why keep a wrong-answer journal?

Practice questions are only useful if you convert each miss into a lesson.
For every question you get wrong on a practice test or lab quiz, capture it here
using the template below. Then during exam week, re-read the journal end-to-end -
this is the single highest-ROI review activity.

## Template

Create files like `notes/2025-01-15-wrong-answers.md` and copy this block per question:

```markdown
## Q<n> - <short topic, e.g. "Conditional Access + guest users">

- **Source**: <MeasureUp / Pluralsight / MS practice / Coach quiz / lab X>
- **Question (paraphrased)**:
  <one paragraph>
- **My answer**: <letter or short text> - Wrong
- **Correct answer**: <letter or short text>
- **Why I was wrong** (root cause, not just "misread"):
  - <e.g. "confused Access Package with Access Review">
- **SC-500 skill bullet this maps to**:
  - <e.g. "Implement entitlement management with access packages">
- **1-sentence rule to remember**:
  - <e.g. "Access Packages GRANT time-bound access; Access Reviews AUDIT existing access.">
- **Follow-up study** (link + estimated minutes):
  - [ ] Read <docs link> (15 min)
  - [ ] Redo lab <n> step <m> (30 min)
- **Confidence after review** (1-5): _
```

## Suggested folder layout

```
notes/
  README.md                   (this file - tracked in git)
  wrong-answers/
    2025-01-15.md
    2025-01-22.md
  cheat-sheets/
    identity-quick-ref.md
    kql-quick-ref.md
  lab-debriefs/
    lab-01-entra-pim.md
```

## Weekly ritual

1. Every Friday: review the week's wrong-answer entries.
2. Every 2 weeks: re-attempt the labs you flagged as "confidence < 4".
3. Exam week: read entire `wrong-answers/` folder end to end, twice.

## Ask the SC-500 Coach agent

Once you have a few entries, ask the SC-500 Coach agent:

> "Read `notes/wrong-answers/` and generate a targeted 60-minute study session
> focused on my weakest SC-500 skill areas."

The Coach agent (in `.github/agents/sc-500-coach.agent.md`) knows to weight
its next teach-block and quiz around your recurring miss themes.
