#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "  Pulling latest changes..."
git -C "${REPO_DIR}" pull

echo ""
bash "${REPO_DIR}/install.sh"
