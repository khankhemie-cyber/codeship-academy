# CODEship Academy — Full Setup Guide

One-command bootstrap:

```bash
npm run setup
```

This installs dependencies, creates `.env.local`, and verifies the production build. **Auth, payments, and AI require your API keys** (steps below).

---

## Tools installed by this repo

| Tool | Purpose | Check |
|------|---------|-------|
| **Node 20+** | App runtime | `node -v` |
| **Vercel CLI** (dev dep) | Deploy + env pull | `npx vercel --version` |
| **Supabase CLI** (npx) | DB push + link | `npx supabase --version` |
| **Stripe CLI** | Local webhooks | `stripe --version` |
| **psql** | Run SQL migrations | `psql --version` |

---

## Step 1 — Supabase (required)

1. Create a project at [supabase.com/dashboard](https://supabase.com/dashboard).
2. Link the repo:
   ```bash
   bash scripts/link-supabase.sh YOUR_PROJECT_REF
   ```
3. Copy keys from **Settings → API** into `.env.local`:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
4. Copy **Settings → Database → Connection string (URI)** into `DATABASE_URL`.
5. Apply schema + curriculum:
   ```bash
   npm run db:push
   ```
6. **Authentication → URL Configuration**:
   - Site URL: `http://localhost:3000` (dev) or `https://app.codeshipacademy.com` (prod)
   - Redirect URLs: `http://localhost:3000/**` and production URL

### Cursor MCP (optional)

`.mcp.json` is included for the Supabase MCP server. In Cursor, authenticate the Supabase MCP plugin to run SQL and manage the project from the IDE.

---

## Step 2 — Stripe (subscriptions)

1. Log in:
   ```bash
   stripe login
   ```
2. Create products/prices in [Stripe Dashboard](https://dashboard.stripe.com/test/products) (test mode).
3. Add to `.env.local`:
   - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` (pk_test_…)
   - `STRIPE_SECRET_KEY` (sk_test_…)
   - `STRIPE_PRICE_MONTHLY`, `STRIPE_PRICE_ANNUAL`, etc.
4. Forward webhooks locally:
   ```bash
   stripe listen --forward-to localhost:3000/api/stripe/webhook
   ```
   Copy the `whsec_…` secret into `STRIPE_WEBHOOK_SECRET`.

---

## Step 3 — Anthropic (AI tutor / assessment / planner)

1. Create an API key at [console.anthropic.com](https://console.anthropic.com).
2. Add `ANTHROPIC_API_KEY=sk-ant-…` to `.env.local`.

---

## Step 4 — Resend (email, optional for dev)

1. Create API key at [resend.com](https://resend.com).
2. Add `RESEND_API_KEY` and `EMAIL_FROM` (verified domain) to `.env.local`.

---

## Step 5 — Run locally

```bash
npm run dev:all
```

Open **http://localhost:3000/en**

Or separately:

```bash
npm run dev          # Next.js only
```

---

## Step 6 — Deploy to Vercel (production)

```bash
bash scripts/link-vercel.sh
```

Set all env vars in Vercel dashboard (same keys as `.env.example`). Then:

```bash
npx vercel --prod
```

Register Stripe webhook: `https://YOUR_DOMAIN/api/stripe/webhook`

---

## Verify configuration

```bash
npm run env:check
npm run build:check
```

---

## SQL file order (reference)

Applied automatically by `npm run db:push`:

1. `schema.sql`
2. `curriculum.sql` + level-specific curriculum files
3. `classes.sql`
4. `school-portal.sql`
5. `patch.sql` (rate limits, streaks, award_xp)
