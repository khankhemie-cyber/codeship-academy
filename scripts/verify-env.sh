#!/usr/bin/env bash
# Compare required keys in .env.example against .env.local (names only).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TEMPLATE=".env.example"
LOCAL=".env.local"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Missing $TEMPLATE"
  exit 1
fi

if [[ ! -f "$LOCAL" ]]; then
  echo "Missing $LOCAL — run: npm run setup"
  exit 1
fi

missing="$(comm -23 \
  <(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$TEMPLATE" | cut -d '=' -f 1 | sort -u) \
  <(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$LOCAL" | cut -d '=' -f 1 | sort -u))"

placeholder="$(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$LOCAL" | grep -E 'your-project|eyJ\.\.\.|sk-ant-\.\.\.|pk_live|sk_live|whsec_\.\.\.|price_\.\.\.|re_\.\.\.|noreply@codeshipacademy' || true)"

echo "==> Environment check"
if [[ -n "$missing" ]]; then
  echo "Missing keys:"
  echo "$missing" | sed 's/^/  - /'
else
  echo "All template keys present in .env.local"
fi

if [[ -n "$placeholder" ]]; then
  echo ""
  echo "Keys still using placeholder values (update before auth/payments/AI):"
  echo "$placeholder" | cut -d '=' -f 1 | sed 's/^/  - /'
fi

# Core keys needed for signup/login
core=(NEXT_PUBLIC_SUPABASE_URL NEXT_PUBLIC_SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY)
for key in "${core[@]}"; do
  val="$(grep "^${key}=" "$LOCAL" | cut -d '=' -f 2- || true)"
  if [[ -z "$val" || "$val" == *"your-project"* || "$val" == "eyJ..." ]]; then
    echo ""
    echo "BLOCKED: $key is not configured — Supabase auth will not work."
    exit 2
  fi
done

echo ""
echo "Supabase core keys look configured."
