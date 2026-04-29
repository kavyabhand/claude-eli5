---
name: eli-commit
description: >
  Generate a plain-language commit message from staged changes. Trigger when the user
  says "/eli-commit", "write a commit message", "commit message eli5", "explain these
  changes for git", "what should my commit say", or "help me write a commit".
---

# ELI-COMMIT — Plain-Language Commit Message

Reads staged changes and writes a commit message that explains the *why*, not just the *what*.

## Steps

### 1. Read staged changes
```bash
git diff --cached 2>/dev/null
```
If nothing staged, also try:
```bash
git diff HEAD~1..HEAD 2>/dev/null
```

### 2. Write the commit message

**Subject line** (required, ≤ 72 chars):
- Starts with a verb: Add, Fix, Remove, Update, Simplify
- Answers "what and why" in plain language
- No jargon in the subject — if a technical term is unavoidable, follow with a plain equivalent

**Body** (optional, use when the why isn't obvious):
- 2–4 bullet points
- Focus on *why* this change was made, not what files changed (the diff shows that)
- Plain language — a teammate who joined yesterday should understand

## Rules

- If the diff is empty, ask the user to describe the change
- Use conventional commit format ONLY if the project already uses it (check existing commits)
- Never summarize the diff literally ("changed line 42 of auth.js") — explain the reason
- Short, clear subject line beats a long, jargon-heavy one every time

## Example

**Staged change**: adds retry logic to API calls

**Output**:
```
Add automatic retry when the server is temporarily unavailable

- Without this, a single slow moment would fail the whole request for the user
- Now we try up to 3 times with a short pause between attempts
- No change to the user-facing experience — this is invisible when it works
```
