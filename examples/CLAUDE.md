# eli5-mode: auto-activation

# Copy this block into your project's CLAUDE.md or ~/.claude/CLAUDE.md
# to give Claude awareness of eli5-mode auto-activation.

## eli5-mode

If a `.eli5rc` file is present in the current project directory:
- Read it at session start
- Auto-activate eli5-mode at the specified level immediately
- Do NOT wait for the user to type an activation command
- The first response in the session must already be in eli5 style

If `.claude/eli5-expert-field` exists, use that as the user's field for /eli-expert
without asking them to repeat it.

Available commands:
/eli5 /eli-kid /eli-teen /eli-adult /eli-expert  — activate at that level
/eli-deeper /eli-simpler                          — step one level on the ladder
/eli-off                                          — deactivate
/eli-status                                       — show current level
/eli-save                                         — export session explanations to eli5-notes.md
/eli-quiz                                         — test understanding of last explanation
/eli-doc                                          — generate ELI5.md glossary for this codebase
