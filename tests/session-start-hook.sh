#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SESSION_HOOK="${ROOT_DIR}/hooks/eli5-session-start.sh"
PER_TURN_HOOK="${ROOT_DIR}/hooks/eli5-per-turn.js"
STATUSLINE_HOOK="${ROOT_DIR}/hooks/eli5-statusline.sh"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "${TEST_DIR}"' EXIT

run_alias_case() {
  local alias="$1"
  local expected="$2"
  local case_dir="${TEST_DIR}/${alias}"
  local work_dir="${case_dir}/work"
  local config_dir="${case_dir}/config"

  mkdir -p "${work_dir}" "${config_dir}"
  printf 'level=%s\n' "${alias}" > "${work_dir}/.eli5rc"

  (
    cd "${work_dir}"
    HOME="${case_dir}/home" \
      CLAUDE_CONFIG_DIR="${config_dir}" \
      CLAUDE_SESSION_ID="test-session" \
      bash "${SESSION_HOOK}" > "${case_dir}/session-output.json"
  )

  local actual
  actual="$(
    python3 - "${config_dir}/.eli5-active.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as state_file:
    print(json.load(state_file)["level"])
PY
  )"

  if [ "${actual}" != "${expected}" ]; then
    printf 'Expected %s to normalize to %s, got %s\n' "${alias}" "${expected}" "${actual}" >&2
    return 1
  fi

  local reinforcement
  reinforcement="$(
    printf '{"prompt":"explain this"}' |
      HOME="${case_dir}/home" \
        CLAUDE_CONFIG_DIR="${config_dir}" \
        CLAUDE_SESSION_ID="test-session" \
        node "${PER_TURN_HOOK}"
  )"

  if [ -z "${reinforcement}" ]; then
    printf 'Expected per-turn reinforcement for %s\n' "${alias}" >&2
    return 1
  fi

  local statusline
  statusline="$(
    HOME="${case_dir}/home" \
      CLAUDE_CONFIG_DIR="${config_dir}" \
      bash "${STATUSLINE_HOOK}"
  )"

  if [ -z "${statusline}" ]; then
    printf 'Expected statusline output for %s\n' "${alias}" >&2
    return 1
  fi
}

run_alias_case "5" "eli5"
run_alias_case "kid" "eli-kid"
run_alias_case "10" "eli-kid"
run_alias_case "teen" "eli-teen"
run_alias_case "15" "eli-teen"
run_alias_case "adult" "eli-adult"
run_alias_case "expert" "eli-expert"

printf 'session-start alias tests passed\n'
