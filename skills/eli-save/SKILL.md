---
name: eli-save
description: >
  Saves all eli5 explanations from the current session to a markdown file. Trigger when
  the user says "/eli-save", "save these explanations", "export eli5 notes", "save to file",
  "keep these explanations", or "write this to a file".
---

# ELI5 Save — Export Session Explanations

Save every eli5-mode explanation from this session to `eli5-notes.md`.

## Steps

1. Review the full conversation history for this session.

2. Identify every response where you gave an eli5-mode explanation.
   Collect: the topic/question, the level used, the explanation text.

3. Check if `eli5-notes.md` already exists:
   ```bash
   test -f eli5-notes.md && echo "exists" || echo "new"
   ```

4. Write (or append) to `eli5-notes.md` using this format:

```markdown
---
saved: [current date and time]
session: [number of explanations in this batch]
---

## [Topic or question]
**Level:** [eli5 / eli-kid / eli-teen / eli-adult / eli-expert]

[The explanation, cleaned up if needed but faithful to what was given]

---
```

   If the file already exists, append below the last `---` separator.
   If new, create with a header:
   ```markdown
   # ELI5 Notes
   Plain-language explanations saved from Claude Code sessions.
   ```

5. After writing, confirm:
   "Saved [N] explanation(s) to `eli5-notes.md`."

   If in eli5 mode: give that confirmation at the current level's style.

## Edge cases

- If no eli5 explanations were given in this session: say so and don't create a file.
- If the user specifies a filename: use that instead of `eli5-notes.md`.
- Strip any code blocks or shell commands from explanations — save only the human-readable text.
