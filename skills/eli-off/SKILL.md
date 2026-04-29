---
name: eli-off
description: >
  Deactivates ELI5 mode and returns to normal communication. Trigger when the user says
  "/eli-off", "stop eli5", "normal mode", "talk normally", "turn off eli5", or "back to normal".
---

# Deactivate ELI5 Mode

ELI5 mode is now off. Return to your normal communication style immediately.

## Steps

1. Clear the state file:
   ```bash
   rm -f .claude/eli5-state.json .claude/eli5-expert-field 2>/dev/null; echo "cleared"
   ```

2. Confirm deactivation in one normal sentence. Example:
   "ELI5 mode off — back to normal. What do you need?"

3. From this point forward, use your standard communication style.
   No more analogy-first. No more jargon restrictions. Full technical vocabulary allowed.

## Important

Do NOT continue using eli5 style after this skill fires.
The deactivation is immediate and complete.
