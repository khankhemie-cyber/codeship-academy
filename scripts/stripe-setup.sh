#!/usr/bin/env bash
# =============================================================================
# CODEship Academy — Stripe products, prices, and webhook bootstrapper
#
# Prereq: Stripe CLI installed and logged in to the CORRECT account/mode:
#   brew install stripe/stripe-cli/stripe   (or see https://stripe.com/docs/stripe-cli)
#   stripe login
#
# Usage:
#   bash scripts/stripe-setup.sh                 # uses your default (test) account
#   For LIVE mode, log in with a live key:
#   stripe login --api-key sk_live_xxx  &&  bash scripts/stripe-setup.sh
#
# Output: prints the STRIPE_PRICE_* and STRIPE_WEBHOOK_SECRET env lines to paste
# into Vercel → Settings → Environment Variables.
# =============================================================================
set -euo pipefail

APP_URL="${NEXT_PUBLIC_APP_URL:-https://app.codeshipacademy.com}"
CURRENCY="cad"

if ! command -v stripe >/dev/null 2>&1; then
  echo "ERROR: Stripe CLI not found. Install it and run 'stripe login' first." >&2
  exit 1
fi

# price <name> <amount-cents> <recurring-interval|once>
price() {
  local name="$1" amount="$2" mode="$3" out
  if [ "$mode" = "once" ]; then
    out=$(stripe prices create \
      --currency "$CURRENCY" \
      --unit-amount "$amount" \
      -d "product_data[name]=$name" 2>/dev/null)
  else
    out=$(stripe prices create \
      --currency "$CURRENCY" \
      --unit-amount "$amount" \
      -d "recurring[interval]=$mode" \
      -d "product_data[name]=$name" 2>/dev/null)
  fi
  echo "$out" | grep -o '"id": *"price_[A-Za-z0-9]*"' | head -1 | grep -o 'price_[A-Za-z0-9]*'
}

echo "Creating products and prices (currency: $CURRENCY)…" >&2

P_MONTHLY=$(price "CODEship Personal Monthly"  1900   month)
P_ANNUAL=$(price  "CODEship Personal Annual"   14900  year)
P_FAMILY=$(price  "CODEship Family Plan"        2900   month)
P_TEACHER=$(price "CODEship Teacher / Classroom" 4900  month)
P_S5=$(price  "CODEship 5 Workshop Sessions"    49500  once)
P_S10=$(price "CODEship 10 Workshop Sessions"   89000  once)
P_S20=$(price "CODEship 20 Workshop Sessions"   158000 once)
P_SCH_M=$(price "CODEship School License Monthly" 29900 month)
P_SCH_A=$(price "CODEship School License Annual"  249900 year)

echo "Creating webhook endpoint…" >&2
WH=$(stripe webhook_endpoints create \
  --url "${APP_URL}/api/stripe/webhook" \
  --enabled-events checkout.session.completed \
  --enabled-events customer.subscription.updated \
  --enabled-events customer.subscription.deleted \
  --enabled-events invoice.payment_succeeded \
  --enabled-events invoice.payment_failed 2>/dev/null)
WH_SECRET=$(echo "$WH" | grep -o '"secret": *"whsec_[A-Za-z0-9]*"' | head -1 | grep -o 'whsec_[A-Za-z0-9]*')

cat <<EOF

# =============================================================================
# DONE. Paste these into Vercel → Settings → Environment Variables (Production):
# =============================================================================
STRIPE_PRICE_MONTHLY=$P_MONTHLY
STRIPE_PRICE_ANNUAL=$P_ANNUAL
STRIPE_PRICE_FAMILY=$P_FAMILY
STRIPE_PRICE_TEACHER=$P_TEACHER
STRIPE_PRICE_SESSIONS_5=$P_S5
STRIPE_PRICE_SESSIONS_10=$P_S10
STRIPE_PRICE_SESSIONS_20=$P_S20
STRIPE_PRICE_SCHOOL_MONTHLY=$P_SCH_M
STRIPE_PRICE_SCHOOL_ANNUAL=$P_SCH_A
STRIPE_WEBHOOK_SECRET=$WH_SECRET

# Also set (from Stripe → Developers → API keys):
# NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
# STRIPE_SECRET_KEY=sk_live_...
EOF
