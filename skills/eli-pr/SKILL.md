---
name: eli-pr
description: >
  Generate a plain-language PR description from the current git diff. Trigger when the user
  says "/eli-pr", "write a PR description", "write this PR simply", "PR description for
  non-technical", "explain this PR to my manager", or "generate PR desc".
---

# ELI-PR — Plain-Language PR Description

Reads the current git diff and writes a PR description a non-engineer can understand.

## Steps

### 1. Get the diff

```bash
git diff main...HEAD 2>/dev/null || git diff master...HEAD 2>/dev/null || git diff HEAD~1..HEAD 2>/dev/null || git diff --cached
```

Also scan recent commit messages:
```bash
git log --oneline -10 2>/dev/null
```

### 2. Check active eli5 level
```bash
cat .claude/eli5-state.json 2>/dev/null || echo "{}"
```
Default to eli-adult if no level is active.

### 3. Write the PR description

Use exactly this structure:

```markdown
## What changed
[One sentence. Plain English. What was built, fixed, or removed — not how.]

## Why
[One sentence. The user/business reason. What problem does this solve?]

## How to test
- [Step 1 — anyone can follow this]
- [Step 2]
- [Step 3 if needed]

## Risk
[One sentence. What could break? Or: "Low risk — no user-facing changes."]
```

## Rules

- **Audience**: your manager, a designer, a PM — intelligent but not technical
- No jargon without an inline plain-language equivalent (e.g. "cache (temporary storage)")
- The "What changed" line must pass the pub test: could you say it to a friend?
- If the diff is empty or unreadable, ask the user to describe the change
- If eli5-mode is active at a specific level, match that level's vocabulary
- Never invent functionality — only describe what the diff shows
