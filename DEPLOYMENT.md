# CODEship Academy — Deployment Guide

**Stack:** Next.js 14 (App Router) · Supabase · Stripe · Resend · Anthropic

---

## Platform: This is a web application

No mobile builds are required. The app is a Progressive Web App (PWA) —
users can install it from the browser on iOS and Android via "Add to Home Screen".

---

## Option A — Vercel (Recommended)

Vercel is the primary target. `vercel.json` is already configured with:
- Weekly digest cron (`0 8 * * 1` UTC)
- Security headers (X-Frame-Options, CSP, HSTS, etc.)

### Steps

1. **Import repo** at https://vercel.com/new → GitHub → `khankhemie-cyber/codeship-academy`

2. **Set environment variables** in Project → Settings → Environment Variables.
   Copy every key from `.env.example` and fill in real values.
   Mark these as **Production only** (never expose to Preview if using test keys):
   - `STRIPE_SECRET_KEY`
   - `STRIPE_WEBHOOK_SECRET`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `ANTHROPIC_API_KEY`
   - `RESEND_API_KEY`
   - `CRON_SECRET`

3. **Deploy** — Vercel auto-deploys on push to `main`.

4. **Custom domain** — Project → Settings → Domains → add `app.codeshipacademy.com`.
   Update `NEXT_PUBLIC_APP_URL` env var to match.

5. **Stripe webhook** — add endpoint in Stripe Dashboard:
   ```
   https://app.codeshipacademy.com/api/stripe/webhook
   Events: checkout.session.completed, customer.subscription.updated,
           customer.subscription.deleted, invoice.payment_failed
   ```
   Copy the signing secret into `STRIPE_WEBHOOK_SECRET`.

6. **Cron authentication** — Vercel sends `Authorization: Bearer $CRON_SECRET`
   to `/api/emails/weekly-digest`. The route already validates this header.

---

## Option B — Cloudflare Pages

> Use this if you prefer Cloudflare's edge network or need to avoid Vercel's
> cold starts. Requires one extra adapter package.

### One-time setup

```bash
npm install --save-dev @cloudflare/next-on-pages
npx cloudflare@latest pages project create codeship-academy
```

Add to `package.json`:
```json
"build:cf": "npx @cloudflare/next-on-pages"
```

Add `wrangler.toml` in the repo root:
```toml
name = "codeship-academy"
compatibility_date = "2024-06-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"
```

### Cloudflare Pages settings

| Setting | Value |
|---|---|
| Framework preset | Next.js |
| Build command | `npx @cloudflare/next-on-pages` |
| Build output dir | `.vercel/output/static` |
| Node.js version | 20 |

Set all environment variables under **Settings → Environment Variables**.

Cloudflare Pages does **not** support Vercel cron syntax. Replace the weekly
digest cron with a **Cloudflare Cron Trigger** in `wrangler.toml`:
```toml
[[triggers.crons]]
cron = "0 8 * * 1"
```
And create a Cloudflare Worker to `fetch` the `/api/emails/weekly-digest`
endpoint with the `Authorization` header.

---

## Required Web Assets (add before launch)

Place these files in `/public/`:

| File | Size | Purpose |
|---|---|---|
| `favicon.ico` | 32×32 | Browser tab |
| `icons/icon-32.png` | 32×32 | Browser tab (PNG) |
| `icons/icon-192.png` | 192×192 | Android home screen |
| `icons/icon-512.png` | 512×512 | PWA splash |
| `icons/icon-maskable-192.png` | 192×192 | Adaptive icon (safe zone = 80%) |
| `icons/icon-maskable-512.png` | 512×512 | Adaptive icon (safe zone = 80%) |
| `icons/apple-touch-icon.png` | 180×180 | iOS Safari "Add to Home Screen" |
| `og-image.png` | 1200×630 | Open Graph / Twitter card |

Recommended tool: https://realfavicongenerator.net — upload a 512×512 SVG/PNG
of the CODEship logo and it generates all sizes including maskable variants.

---

## Supabase Setup

1. Create project at https://app.supabase.com
2. Run SQL files in order (or use `npm run db:push` after setting `DATABASE_URL`):
   ```
   supabase/schema.sql
   supabase/curriculum.sql
   supabase/curriculum-explorers.sql
   supabase/curriculum-explorers-projects.sql
   supabase/curriculum-builders.sql
   supabase/curriculum-builders-quizzes.sql
   supabase/curriculum-builders-quizzes-complete.sql
   supabase/curriculum-builders-projects.sql
   supabase/curriculum-developers.sql
   supabase/curriculum-developers-quizzes.sql
   supabase/classes.sql
   supabase/school-portal.sql
   supabase/patch.sql
   ```
3. Enable Row Level Security on all tables (should already be in schema.sql).
4. Under **Authentication → URL Configuration**, set:
   - Site URL: `https://app.codeshipacademy.com`
   - Redirect URLs: `https://app.codeshipacademy.com/**`

---

## Resend Setup

1. Add and verify your sending domain at https://resend.com/domains
2. Add DNS records (SPF, DKIM, DMARC) as instructed by Resend
3. Create API key with **Send access only** (not full access)
4. Set `EMAIL_FROM` to an address on your verified domain

---

## Local Development

See **[SETUP.md](./SETUP.md)** for the full guide. Quick start:

```bash
npm run setup        # install deps, create .env.local, verify build
# configure Supabase keys in .env.local
npm run db:push      # apply all SQL
npm run dev:all      # Next.js + Stripe webhook forwarder
```

Open http://localhost:3000/en
