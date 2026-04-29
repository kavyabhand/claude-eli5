#!/usr/bin/env node
// eli5-per-turn.js — UserPromptSubmit hook
//
// Per-turn reinforcement: injects a ~25-token reminder of the active eli5 level
// on every user prompt. Prevents the drift that makes users re-activate.
//
// Also handles:
//   - Level switch commands (/eli5, /eli-kid, /eli-teen, /eli-adult, /eli-expert)
//   - Deactivation commands (/eli-off, stop eli5, normal mode, talk normally)
//   Both update the flag file so the statusline and session-start hook stay in sync.

'use strict';
const fs   = require('fs');
const path = require('path');
const os   = require('os');

const claudeDir = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const flagPath  = path.join(claudeDir, '.eli5-active.json');
const sessionId = process.env.CLAUDE_SESSION_ID || '';

// Level metadata — compact style hints for per-turn injection
const LEVELS = {
  'eli5':      { label: '5yo',            hint: 'Toys/food/animals. ≤15 words/sentence.' },
  'eli-kid':   { label: '10yo',           hint: 'School analogies. Cause-effect framing.' },
  'eli-teen':  { label: '15yo',           hint: 'Pop culture/gaming. Get to the point fast.' },
  'eli-adult': { label: 'smart adult',    hint: 'Real-world analogies. No domain knowledge assumed.' },
  'eli-expert':{ label: 'expert bridge',  hint: 'Use their domain vocabulary as the bridge.' },
};

// Level switch command → level key
const LEVEL_CMDS = {
  '/eli5': 'eli5', '/eli-kid': 'eli-kid', '/eli-teen': 'eli-teen',
  '/eli-adult': 'eli-adult', '/eli-expert': 'eli-expert',
};

// Deactivation patterns
const DEACTIVATE = /\b(stop eli5|normal mode|talk normally|\/eli-off)\b/i;

// Level switch patterns
const LEVEL_SWITCH = /^(\/eli5|\/eli-kid|\/eli-teen|\/eli-adult|\/eli-expert)\b/i;

// ── Flag file helpers ────────────────────────────────────────────────────────

function readState() {
  try {
    const st = fs.lstatSync(flagPath);
    if (st.isSymbolicLink() || !st.isFile() || st.size > 256) return null;
    const raw = fs.readFileSync(flagPath, 'utf8').trim();
    const obj = JSON.parse(raw);
    if (!LEVELS[obj.level]) return null;
    return obj;
  } catch (e) { return null; }
}

function writeState(level) {
  try {
    const meta = LEVELS[level];
    const content = JSON.stringify({ level, label: meta.label, session: sessionId });
    const tmp = flagPath + '.tmp.' + process.pid;
    fs.writeFileSync(tmp, content, { mode: 0o600 });
    fs.renameSync(tmp, flagPath);
  } catch (e) { /* silent fail */ }
}

function clearState() {
  try { fs.unlinkSync(flagPath); } catch (e) { /* already gone */ }
}

// ── Main ─────────────────────────────────────────────────────────────────────

let input = '';
process.stdin.on('data', chunk => { input += chunk; });
process.stdin.on('end', () => {
  try {
    const data   = JSON.parse(input);
    const prompt = (data.prompt || '').trim();
    const lower  = prompt.toLowerCase();

    // 1. Deactivation check (highest priority)
    if (DEACTIVATE.test(prompt)) {
      clearState();
      process.exit(0);
    }

    // 2. Level switch check
    const switchMatch = prompt.match(LEVEL_SWITCH);
    if (switchMatch) {
      const newLevel = LEVEL_CMDS[switchMatch[1].toLowerCase()];
      if (newLevel) {
        writeState(newLevel);
        // The skill itself handles the response; we don't inject context here
        // so the skill's activation message is clean
        process.exit(0);
      }
    }

    // 3. Read current state
    const state = readState();
    if (!state) process.exit(0);

    // 4. Session scope check — don't carry state across sessions
    if (sessionId && state.session && state.session !== sessionId) {
      clearState();
      process.exit(0);
    }

    // 5. Inject per-turn reinforcement (~25 tokens)
    const meta = LEVELS[state.level];
    if (!meta) process.exit(0);

    const context =
      `ELI5 ACTIVE (${state.level} / ${meta.label}). ` +
      `${meta.hint} ` +
      `Core rules: analogy-first, kill jargon, short sentences, accurate, concrete, no condescension. ` +
      `Persist every response. /eli-off to deactivate.`;

    process.stdout.write(JSON.stringify({
      hookSpecificOutput: {
        hookEventName: 'UserPromptSubmit',
        additionalContext: context,
      }
    }));

  } catch (e) { /* silent fail — never block a user prompt */ }
});
