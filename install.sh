#!/usr/bin/env bash
set -e

SKILL_NAME="eli5-mode"
SKILLS_DIR="${HOME}/.claude/skills"
DEST="${SKILLS_DIR}/${SKILL_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${SCRIPT_DIR}/${SKILL_NAME}"

echo "Installing ${SKILL_NAME}..."

if [ ! -d "${SOURCE}" ]; then
  echo "Error: skill directory not found at ${SOURCE}"
  echo "Run this script from the root of the cloned repository."
  exit 1
fi

mkdir -p "${SKILLS_DIR}"

if [ -d "${DEST}" ]; then
  echo "Existing install found — replacing it."
  rm -rf "${DEST}"
fi

cp -r "${SOURCE}" "${DEST}"

echo "Done. ${SKILL_NAME} installed to ${DEST}"
echo ""
echo "Start a new Claude Code session and say 'eli5' to activate."
