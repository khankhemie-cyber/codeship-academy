#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Installing dependencies"
npm install

if [[ ! -f .env.local ]]; then
  echo "==> Creating .env.local from .env.example"
  cp .env.example .env.local
  CRON_SECRET="$(openssl rand -hex 32)"
  if grep -q '^CRON_SECRET=' .env.local; then
    sed -i "s|^CRON_SECRET=.*|CRON_SECRET=${CRON_SECRET}|" .env.local
  fi
  if grep -q '^NEXT_PUBLIC_APP_URL=' .env.local; then
    sed -i 's|^NEXT_PUBLIC_APP_URL=.*|NEXT_PUBLIC_APP_URL=http://localhost:3000|' .env.local
  fi
  echo "    Fill Supabase, Stripe, Anthropic, and Resend keys in .env.local before signing in."
else
  echo "==> .env.local already exists (unchanged)"
fi

echo "==> Verifying build"
npm run build:check

echo ""
echo "Local setup complete."
echo "  1. Edit .env.local with your Supabase + API keys"
echo "  2. Run SQL files on Supabase (see DEPLOYMENT.md)"
echo "  3. npm run dev  →  http://localhost:3000"
echo "  4. stripe listen --forward-to localhost:3000/api/stripe/webhook  (optional)"
