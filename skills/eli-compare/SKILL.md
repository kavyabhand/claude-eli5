---
name: eli-compare
description: >
  Compare two concepts side by side at the current eli5 level. Trigger when the user says
  "/eli-compare", "compare X vs Y", "what's the difference between X and Y",
  "eli5 X versus Y", "X vs Y explained simply", or "help me understand X and Y".
---

# ELI-COMPARE — Side-by-Side Comparison

Usage: `/eli-compare X vs Y` or `/eli-compare X Y`

Extract the two concepts from the prompt. If only one is mentioned, ask: "Compare it to what?"

## Format

```
**[Concept A]** — [one-line analogy from everyday life]
**[Concept B]** — [one-line analogy using the SAME everyday domain]

**Same**: [what they genuinely have in common, one sentence]
**Different**: [the key distinction — the one thing that matters most, one sentence]

**Use [A] when**: [concrete scenario]
**Use [B] when**: [concrete scenario]
```

## Rules

- Use the **same analogy domain** for both sides (both use cooking, or both use sports — not mixed)
- Match the active eli5 level vocabulary (or eli-adult if not active)
- Maximum 6 bullets total — this is a quick orientation, not a deep dive
- The "different" line must be the single most important distinction, not a list
- If asked to compare more than 2 things, do them pairwise: A vs B, then B vs C
- Check `~/.claude/skills/eli5-mode/references/analogy-bank.md` for ready-made analogies

## Example

**Input**: `/eli-compare SQL vs NoSQL`

**Output**:
> **SQL** — like a spreadsheet where every row must follow the exact same column layout.
> **NoSQL** — like a folder of sticky notes where each note can have whatever's written on it.
>
> **Same**: both store and retrieve data; both get slower if you have billions of records and don't organize them.
> **Different**: SQL forces structure upfront; NoSQL lets structure evolve as you go.
>
> **Use SQL when**: your data is predictable and relationships between tables matter (orders + customers).
> **Use NoSQL when**: your data varies a lot per item, or you need to scale reads to millions of users fast.
