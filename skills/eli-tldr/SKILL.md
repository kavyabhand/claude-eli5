---
name: eli-tldr
description: >
  Summarize any concept in exactly 3 plain-language bullets. Trigger when the user says
  "/eli-tldr", "tl;dr", "3 bullets", "give me the gist", "quick version",
  "summarize this", "key points only", or "bullet points please".
---

# ELI-TLDR — 3-Bullet Summary

Exactly 3 bullets. No prose before or after.

## Format

```
- **What it is**: [one analogy or concrete description]
- **Why it matters**: [the real-world impact — what breaks without it, or what it enables]
- **Key thing to know**: [the one thing that trips people up, or the most important nuance]
```

## Rules

- Each bullet ≤ 20 words
- No jargon without an immediate parenthetical — but prefer to avoid jargon entirely
- If the topic wasn't stated, ask before answering
- Match the active eli5 level (or eli-adult if not active)
- If 3 bullets genuinely isn't enough for the concept, say so and offer /eli-adult [topic]

## Example

**Input**: `/eli-tldr JWT tokens`

**Output**:
- **What it is**: A tamper-proof signed note your server hands you — like a stamped wristband at a concert.
- **Why it matters**: The server doesn't need to remember you — it just checks the stamp. Scales to millions of users.
- **Key thing to know**: The stamp expires. If it doesn't, a stolen wristband works forever — always set an expiry.
