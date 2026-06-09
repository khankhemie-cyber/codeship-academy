#!/usr/bin/env bash
# Full CODEship Academy bootstrap — run once per machine.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "=============================================="
echo " CODEship Academy — full setup"
echo "=============================================="

echo ""
echo "==> 1/6 Node dependencies"
npm install

echo ""
echo "==> 2/6 CLI tools"
command -v stripe >/dev/null || { echo "Install Stripe CLI: https://stripe.com/docs/stripe-cli"; exit 1; }
command -v psql >/dev/null || { echo "Install PostgreSQL client (psql)"; exit 1; }
npx supabase --version >/dev/null
npx vercel --version >/dev/null
echo "    stripe $(stripe --version 2>/dev/null | head -1)"
echo "    supabase $(npx supabase --version 2>/dev/null)"
echo "    vercel $(npx vercel --version 2>/dev/null)"

echo ""
echo "==> 3/6 Local environment file"
if [[ ! -f .env.local ]]; then
  cp .env.example .env.local
  CRON_SECRET="$(openssl rand -hex 32)"
  sed -i "s|^CRON_SECRET=.*|CRON_SECRET=${CRON_SECRET}|" .env.local
  sed -i 's|^NEXT_PUBLIC_APP_URL=.*|NEXT_PUBLIC_APP_URL=http://localhost:3000|' .env.local
  # Use Stripe test keys placeholder hint
  sed -i 's|^NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live|NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test|' .env.local || true
  sed -i 's|^STRIPE_SECRET_KEY=sk_live|STRIPE_SECRET_KEY=sk_test|' .env.local || true
  echo "    Created .env.local with generated CRON_SECRET"
else
  echo "    .env.local exists"
fi

echo ""
echo "==> 4/6 Environment verification"
if bash scripts/verify-env.sh; then
  ENV_OK=1
else
  ENV_OK=0
  echo "    (Expected until you add Supabase keys — see SETUP.md)"
fi

echo ""
echo "==> 5/6 Database (optional)"
if [[ "${ENV_OK:-0}" -eq 1 && -n "${DATABASE_URL:-}" ]]; then
  bash scripts/db-push.sh || echo "    db:push skipped or failed — run manually: npm run db:push"
elif npx supabase projects list 2>/dev/null | grep -q .; then
  bash scripts/db-push.sh 2>/dev/null || echo "    Link Supabase first: bash scripts/link-supabase.sh <project-ref>"
else
  echo "    Skipped — configure Supabase then run: npm run db:push"
fi

echo ""
echo "==> 6/6 Build verification"
npm run build:check

echo ""
echo "=============================================="
echo " Setup complete"
echo "=============================================="
echo ""
echo "Next steps (one-time, requires your accounts):"
echo "  1. Supabase:  bash scripts/link-supabase.sh <project-ref>"
echo "                Fill .env.local API keys + DATABASE_URL"
echo "  2. Database:  npm run db:push"
echo "  3. Stripe:    stripe login && create test products/prices"
echo "  4. Anthropic: add ANTHROPIC_API_KEY to .env.local"
echo "  5. Resend:    add RESEND_API_KEY + verify domain (optional for email)"
echo "  6. Vercel:    bash scripts/link-vercel.sh  (production deploy)"
echo "  7. Run app:   npm run dev:all  →  http://localhost:3000/en"
echo ""
echo "See SETUP.md for detailed instructions."
