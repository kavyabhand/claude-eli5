---
name: eli-recap
description: >
  Generate a structured summary of everything explained in this session and save a concept
  index for future sessions. Trigger when the user says "/eli-recap", "session summary",
  "what did we cover", "summarize the session", "what did I learn today", or "recap".
---

# ELI-RECAP — Session Digest + Cross-Session Memory

Produces a structured digest of this session and saves a concept index for future reference.

## Format

```markdown
## What we covered
- **[Concept]** — [one plain-language sentence summary]
- **[Concept]** — [one plain-language sentence summary]
[Group by topic if multiple topics came up]

## Key analogies that stuck
- [Concept]: [the analogy] 
- [Concept]: [the analogy]
[Best 3–5 only]

## Open questions
[Anything that came up but wasn't fully explained — or "None — good coverage!"]

---
*Level: [active eli5 level] · Session: [today's date]*
```

## Save concept index (cross-session memory)

After producing the recap, save a concept index so future sessions can build on this one:

```bash
node -e "
const fs = require('fs');
const f = '.claude/eli5-concepts.json';
let c = {};
try { c = JSON.parse(fs.readFileSync(f, 'utf8')); } catch {}
const today = new Date().toISOString().split('T')[0];
// Concepts are extracted from the session summary above
if (!c.sessions) c.sessions = [];
c.sessions.push({ date: today, count: 0 }); // updated by the skill with actual concepts
fs.writeFileSync(f, JSON.stringify(c, null, 2));
" 2>/dev/null || true
```

Write the actual concept list (extracted from your session recap) to `.claude/eli5-concepts.json`:

```json
{
  "sessions": [
    {
      "date": "YYYY-MM-DD",
      "level": "eli-adult",
      "concepts": ["concept1", "concept2", "concept3"]
    }
  ]
}
```

## Rules

- If nothing has been explained in this session: "Nothing yet — ask me anything and I'll explain it at your level!"
- Keep concept summaries to one sentence — this is a reference, not a re-explanation
- After the recap, always offer: "Type /eli-save to export this to `eli5-notes.md`"
- Also offer: "Type /eli-quiz to test yourself on what we covered"
- Match the eli5 level that was active for most of the session
