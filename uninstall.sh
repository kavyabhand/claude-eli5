#!/usr/bin/env bash
set -e

SKILL_NAME="eli5-mode"
DEST="${HOME}/.claude/skills/${SKILL_NAME}"

if [ ! -d "${DEST}" ]; then
  echo "${SKILL_NAME} is not installed."
  exit 0
fi

rm -rf "${DEST}"
echo "Uninstalled ${SKILL_NAME}."
