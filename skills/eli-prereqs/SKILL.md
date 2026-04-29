---
name: eli-prereqs
description: >
  Show what you need to understand before tackling a concept — a learning path, not just
  a definition. Trigger when the user says "/eli-prereqs", "what do I need to know first",
  "prerequisites for X", "learning path for X", "where do I start with X",
  "what should I learn before X", or "I want to understand X from scratch".
---

# ELI-PREREQS — Learning Path

Given a topic, map the path from zero to understanding — so you know where to start, not just where to end up.

## Steps

### 1. Check what the user already knows (optional)
If the user mentioned their background in this session, use it.
Otherwise, ask once: "What's your starting point? (e.g., beginner, some coding, experienced in [field])"
If they want to skip this: proceed with eli-adult level assumptions.

### 2. Check past concepts (cross-session awareness)
```bash
cat .claude/eli5-concepts.json 2>/dev/null | head -50
```
If a concept appears there, it's already been covered — skip it or mark as "(you've seen this)".

### 3. Produce the learning path

Format:
```
## To understand [topic], you first need:

1. **[Prerequisite A]** — [one plain-language sentence. How long: ~X hours/days]
2. **[Prerequisite B]** — [one plain-language sentence. How long: ~X hours/days]
3. **[Prerequisite C]** — [one plain-language sentence. How long: ~X hours/days]

## Then: [Topic itself]
[One-sentence plain-language summary of what it is, once you have the above]

## After this, you'll be ready for:
- [Next concept 1]
- [Next concept 2]

## Start here →
[The single best first step — a command, a tutorial, a book, or a concept to ask about next]
```

## Rules

- Keep prerequisites concrete — no "understand programming fundamentals" vagueness
- Time estimates should be honest, not optimistic
- Flag prerequisites that are themselves complex: "(this one takes a few days — don't rush it)"
- Maximum 5 prerequisites — if there are more, chain them: do A, then B, then ask again
- "Start here →" must be actionable: something specific to read, watch, or ask about
- Match the active eli5 level (or eli-adult if not active)
