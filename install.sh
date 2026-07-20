#!/bin/bash
# git-agent installer
set -e

INSTALL_DIR="${1:-/usr/local/bin}"

echo "Installing git-agent tools to $INSTALL_DIR ..."
cp "$(dirname "$0")/git-agent-commit" "$INSTALL_DIR/"
cp "$(dirname "$0")/git-agent-log"    "$INSTALL_DIR/"
cp "$(dirname "$0")/git-agent-index"  "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/git-agent-commit" "$INSTALL_DIR/git-agent-log" "$INSTALL_DIR/git-agent-index"

echo ""
echo "✓ git-agent installed!"
echo ""
echo "Usage:"
echo "  cd your-repo"
echo "  git agent-commit --context context.json -m \"feat: ...\""
echo "  git agent-log"
echo "  git agent-log --search \"attention\""
echo "  git agent-index"
echo "  git agent-index --query \"tiling\""
echo ""
echo "To share agent context notes with remote:"
echo "  git push origin refs/notes/agent-context"
echo ""
echo "To pull from remote (on clone side):"
echo "  git fetch origin refs/notes/agent-context:refs/notes/agent-context"
