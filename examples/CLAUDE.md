<!-- eli5-mode:start -->
## eli5-mode

If a `.eli5rc` file is present in the current project directory:
- Read it at session start
- Auto-activate eli5-mode at the specified level immediately
- Do NOT wait for the user to type an activation command
- The first response in the session must already be in eli5 style

If `.claude/eli5-expert-field` exists, use that as the user's field for /eli-expert
without asking them to repeat it.

Available commands:

Levels:      /eli5 /eli-kid /eli-teen /eli-adult /eli-expert
Navigate:    /eli-deeper /eli-simpler
On/off:      /eli-off /eli-status

Learning:    /eli-compare /eli-prereqs /eli-teach /eli-quiz /eli-recap
Formats:     /eli-brief /eli-tweet /eli-tldr
Workflow:    /eli-pr /eli-commit
Memory:      /eli-remember /eli-save /eli-doc
<!-- eli5-mode:end -->
