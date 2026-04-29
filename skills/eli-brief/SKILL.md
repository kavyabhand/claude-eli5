---
name: eli-brief
description: >
  Generate a 3-sentence plain-language summary safe to send to executives or clients.
  Trigger when the user says "/eli-brief", "executive summary", "tl;dr for my boss",
  "explain briefly for non-technical", "3 sentences", "send to my manager",
  "non-technical summary", or "boardroom version".
---

# ELI-BRIEF — Executive Summary

Exactly 3 sentences. Safe to paste into Slack, email, or a board deck.

## Format

```
[What it is] — one concrete analogy, zero jargon.
[Why it matters] — the real-world impact or user benefit.
[What to watch for / what action is needed] — the one thing they should know or decide.
```

## Rules

- Each sentence ≤ 20 words
- No technical terms without an immediate plain parenthetical — but prefer to avoid them entirely
- Assume the reader is smart and busy, not technical
- Tone: confident and clear, not dumbed-down
- If the topic wasn't stated in the command, ask: "What's the topic and who's the audience?"
- After the 3 sentences, offer: "Need a longer version? Try /eli-adult [topic]"

## Example

**Input**: `/eli-brief rate limiting`

**Output**:
> Rate limiting is like a bouncer at a door who lets in only a set number of people per minute.
> It stops one bad actor from overwhelming a system and slowing it down for everyone else.
> Right now our API allows 100 requests per minute per user — if that's causing issues, we can raise or lower it.
