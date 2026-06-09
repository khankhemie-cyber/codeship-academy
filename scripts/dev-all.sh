#!/usr/bin/env bash
# Start Next.js dev server and Stripe webhook forwarder (tmux).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SESSION="codeship-dev"
TMUX="tmux -f /exec-daemon/tmux.portal.conf"
NODE_BIN="$(command -v node || true)"
NPM_BIN="$(command -v npm || true)"
if [[ -z "$NPM_BIN" ]]; then
  echo "npm not found in PATH"
  exit 1
fi
NODE_DIR="$(dirname "$NPM_BIN")"
RUN_DEV="unset npm_config_prefix; export PATH=\"$NODE_DIR:\$PATH\"; cd \"$ROOT\" && npm run dev"

if ! $TMUX has-session -t "=$SESSION" 2>/dev/null; then
  $TMUX new-session -d -s "$SESSION" -c "$ROOT" -- "${SHELL:-bash}" -l
fi

$TMUX send-keys -t "$SESSION:0.0" "$RUN_DEV" C-m

if command -v stripe >/dev/null && stripe config --list 2>/dev/null | grep -q test_mode_api_key; then
  $TMUX split-window -h -t "$SESSION:0.0"
  $TMUX send-keys -t "$SESSION:0.1" "unset npm_config_prefix; stripe listen --forward-to localhost:3000/api/stripe/webhook" C-m
  echo "Stripe listener started in tmux pane 1."
else
  echo "Stripe CLI not logged in — run: stripe login"
  echo "Then re-run: npm run dev:all"
fi

echo "Dev server: http://localhost:3000/en"
echo "Attach: tmux -f /exec-daemon/tmux.portal.conf attach -t $SESSION"
