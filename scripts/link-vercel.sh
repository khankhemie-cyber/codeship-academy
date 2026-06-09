#!/usr/bin/env bash
# Link repo to Vercel and pull environment variables.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Vercel login"
npx vercel login

echo "==> Link project"
npx vercel link --yes

echo "==> Pull env vars into .env.local"
npx vercel env pull .env.local --yes

echo ""
echo "Verify keys: bash scripts/verify-env.sh"
echo "Deploy preview: npx vercel"
