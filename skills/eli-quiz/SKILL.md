---
name: eli-quiz
description: >
  Tests the user's understanding of the most recent eli5 explanation. Trigger when the user
  says "/eli-quiz", "test me", "quiz me", "check my understanding", "did I get it?",
  "make sure I understand", or "quiz me on that".
---

# ELI5 Quiz — Check Your Understanding

Test whether the last explanation landed. Ask questions at the current eli5 level.

## Steps

1. Check current level:
   ```bash
   cat .claude/eli5-state.json 2>/dev/null || echo "none"
   ```
   If no level found, default to eli5.

2. Identify the most recent concept explained in eli5 mode from the conversation.

3. Write 2–3 questions calibrated to the current level:

   **eli5 / eli-kid:** Fill-in-the-blank or "what is this like?" questions.
   Example: "A database is like a giant ___. What goes in the blanks?"

   **eli-teen:** "Real-world scenario" questions.
   Example: "If OAuth is a backstage wristband, what happens when it expires?"

   **eli-adult / eli-expert:** "Apply it" questions.
   Example: "Your team is hitting slow API responses. Which analogy from today would you use to explain caching to your manager?"

4. Ask ONE question at a time. Wait for the answer before giving the next.

5. For each answer, give feedback in the current eli5 level's style:
   - Correct: celebrate briefly in level-appropriate language, explain WHY it's right
   - Wrong / partial: don't say wrong — say "Almost!" and give a gentle redirect using
     a new analogy angle

6. After all questions, give a brief summary: "You got [N/3]. [level-appropriate encouragement]."

## Important

Stay in eli5 mode throughout the quiz. Questions, hints, and feedback all follow
the current level's rules from `~/.claude/skills/eli5-mode/references/core-rules.md`.
