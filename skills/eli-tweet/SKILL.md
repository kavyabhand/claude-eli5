---
name: eli-tweet
description: >
  Explain any concept in 280 characters or fewer. Trigger when the user says "/eli-tweet",
  "explain in a tweet", "280 characters", "one tweet explanation", "tweet-length",
  or "explain in one sentence".
---

# ELI-TWEET — 280-Character Explanation

One shot. ≤ 280 characters. No threads.

## Rules

- One concrete analogy or image — no abstract descriptions
- If you can cut a word, cut it
- Count characters. If over 280, cut until it fits
- After answering, show the character count: `(247/280 chars)`
- If the topic wasn't stated in the command, ask before answering
- Match the active eli5 level (or eli-adult if not active)

## Challenge mode

If the user says "shorter", cut to ≤ 140 characters.
If they say "even shorter", aim for ≤ 100.
Never sacrifice accuracy for brevity — if a concept genuinely can't fit, say why and offer /eli-brief instead.

## Why this matters

If you can't say it in 280 characters, you don't fully understand it. This command double-checks both of you.

## Example

**Input**: `/eli-tweet what is recursion`

**Output**:
> A function that calls itself to solve a smaller version of the same problem. Like Russian dolls — open one, find another, keep going until you find the tiny one at the center that doesn't open. (193/280 chars)
