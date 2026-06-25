#!/bin/sh
#
# Run this script once after cloning the repo to enable the Git hooks:
#   sh setup-hooks.sh
#

git config core.hooksPath .githooks
chmod +x .githooks/pre-commit

echo "✅ Git hooks configured. Pre-commit dart format check is now active."
