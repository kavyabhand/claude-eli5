---
name: eli-status
description: >
  Shows the current eli5-mode status and level. Trigger when the user says "/eli-status",
  "what level am i on", "am i in eli5 mode", "what's my current mode", or "eli5 status".
---

# ELI5 Status

Report the current eli5 communication mode.

## Steps

1. Check the state file:
   ```bash
   cat .claude/eli5-state.json 2>/dev/null || echo "none"
   ```

2. Format the response based on the output:

**If state file exists:**
```
eli5-mode   ● active
Level       [label from state file, e.g. "15-year-old"]
Command     [level from state file, e.g. /eli-teen]
```
Then add one sentence in the current level's style confirming mode is active.

**If no state file or "none":**
```
eli5-mode   ○ inactive
Level       —
```
Then one normal sentence: "No eli5 mode active. Say 'eli5' or use /eli5, /eli-kid,
/eli-teen, /eli-adult, or /eli-expert to activate."

**If expert level is active, also check for saved field:**
```bash
cat .claude/eli5-expert-field 2>/dev/null || echo ""
```
If found, include: `Field  [saved field]`

## Note

Report only — do not change the current mode.
