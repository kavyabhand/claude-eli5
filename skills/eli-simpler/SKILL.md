---
name: eli-simpler
description: >
  Steps one level simpler on the eli5 ladder. Trigger when the user says "/eli-simpler",
  "simpler please", "too complex", "dumb it down more", "step it down", "even simpler".
  Must be in eli5 mode for this to do anything meaningful.
---

# ELI5 Simpler — Step Down One Level

Move one step simpler on the level ladder, then re-explain the last concept at the new level.

## The Level Ladder

```
eli5 (1) ← eli-kid (2) ← eli-teen (3) ← eli-adult (4) ← eli-expert (5)
 ↑ most simple
```

## Steps

1. Check current level:
   ```bash
   cat .claude/eli5-state.json 2>/dev/null || echo "none"
   ```

2. Determine next level down:
   - eli-expert → eli-adult
   - eli-adult → eli-teen
   - eli-teen → eli-kid
   - eli-kid → eli5
   - eli5 → already at simplest; tell the user in one short sentence (in eli5 style)

3. Update state:
   ```bash
   printf '{"level":"[new-level]","label":"[new-label]"}' > .claude/eli5-state.json
   ```

4. Acknowledge the level change in one sentence at the NEW level's style.

5. Re-explain the most recent concept at the new level — don't just announce the switch.
   If no concept was recently explained, just confirm the new level is active.

## Important

Apply the new level's rules immediately. Read the core rules at:
`~/.claude/skills/eli5-mode/references/core-rules.md`
