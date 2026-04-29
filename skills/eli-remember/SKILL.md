---
name: eli-remember
description: >
  Save a good analogy to the personal analogy library for use in future sessions.
  Trigger when the user says "/eli-remember", "save that analogy", "remember that one",
  "add to my analogies", "that was a good analogy save it", or "keep that analogy".
---

# ELI-REMEMBER — Save Analogy to Personal Library

Saves an analogy to `custom-analogies.md` so it's available in all future sessions.

## Steps

### 1. Identify the analogy to save

- If the user specified one in the command (e.g., `/eli-remember OAuth is like a valet key`): use exactly that
- If not: use the most recently stated analogy from the conversation
- If unclear, ask: "Which analogy should I save? Paste it here."

### 2. Extract the concept and analogy text

Format: `**[Concept]**: [analogy in ≤ 25 words]`

If the analogy is longer than 25 words, distill it to its essential image.

### 3. Check for duplicates

```bash
CUSTOM="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/eli5-mode/references/custom-analogies.md"
grep -i "[concept]" "$CUSTOM" 2>/dev/null || echo "not found"
```

If a similar entry already exists: "You already have an analogy for [concept]: [existing]. Replace it? (yes/no)"

### 4. Append to custom-analogies.md

```bash
CUSTOM="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/eli5-mode/references/custom-analogies.md"
printf '\n- **%s**: %s\n' "[Concept]" "[Analogy text]" >> "$CUSTOM"
```

### 5. Confirm

"Saved: **[Concept]** → [analogy text]

This analogy will be used automatically in all future sessions before the built-in bank."

## Rules

- Keep saved analogies short and concrete — the image should land in one reading
- Never save abstract descriptions ("it's like a system that manages...") — only concrete images
- Custom analogies are checked first, before the built-in analogy bank — the user's preferred ones always win
