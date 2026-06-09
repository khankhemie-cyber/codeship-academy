#!/usr/bin/env bash
# Link this repo to a remote Supabase project (one-time).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Supabase login (opens browser if needed)"
npx supabase login

if [[ -z "${1:-}" ]]; then
  echo ""
  echo "Usage: bash scripts/link-supabase.sh <project-ref>"
  echo "Find project ref in Supabase dashboard URL: https://supabase.com/dashboard/project/<project-ref>"
  npx supabase projects list
  exit 1
fi

npx supabase link --project-ref "$1"

echo ""
echo "Linked. Next:"
echo "  1. Copy API keys from Supabase → Settings → API into .env.local"
echo "  2. Set DATABASE_URL from Supabase → Settings → Database → Connection string (URI)"
echo "  3. npm run db:push"
