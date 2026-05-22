# CODEship Academy — Pre-Launch Checklist

> **Platform: Web App (PWA)** — No App Store or Google Play submission required.
> Users install via browser "Add to Home Screen" on iOS/Android.

---

## Infrastructure

- [ ] Supabase project created and all SQL files run in order (see DEPLOYMENT.md)
- [ ] Supabase RLS policies verified: `SELECT auth.uid()` returns correct user in SQL editor
- [ ] Supabase Auth email templates customised (Confirm signup, Password reset)
- [ ] Supabase Auth redirect URLs include `https://app.codeshipacademy.com/**`
- [ ] Stripe account live-mode activated (business info, bank account added)
- [ ] Stripe products and prices created; all `STRIPE_PRICE_*` env vars populated
- [ ] Stripe webhook endpoint registered for `https://app.codeshipacademy.com/api/stripe/webhook`
- [ ] Stripe webhook test event sent and logged in audit_logs ✓
- [ ] Resend sending domain verified (SPF + DKIM + DMARC in DNS)
- [ ] Weekly digest cron tested manually: `POST /api/emails/weekly-digest` with `Authorization: Bearer $CRON_SECRET`

## Deployment

- [ ] All environment variables set in Vercel/Cloudflare dashboard (none missing from `.env.example`)
- [ ] Production deploy triggered and succeeded (`npm run build` green)
- [ ] Custom domain `app.codeshipacademy.com` added and SSL cert provisioned
- [ ] `NEXT_PUBLIC_APP_URL` set to production URL (no trailing slash)
- [ ] `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` uses **live** key (not `pk_test_`)
- [ ] `STRIPE_SECRET_KEY` uses **live** key (not `sk_test_`)

## Security

- [ ] HSTS header verified: `curl -I https://app.codeshipacademy.com | grep Strict`
- [ ] `X-Frame-Options: DENY` confirmed (prevents clickjacking)
- [ ] CSP header present and does not block any production features
- [ ] `ANTHROPIC_API_KEY` is NOT in any NEXT_PUBLIC_ variable (server-side only)
- [ ] `SUPABASE_SERVICE_ROLE_KEY` is NOT in any NEXT_PUBLIC_ variable
- [ ] Stripe webhook signature verification is active (route rejects bad signatures)
- [ ] SQL injection not possible — confirm parameterised queries only (Supabase SDK enforces this)
- [ ] `.env.local` is in `.gitignore` and NOT committed to the repo

## Legal & Compliance (Canadian law — PIPEDA + CASL)

- [ ] Privacy Policy page live at `/en/privacy` and `/fr/privacy`
- [ ] Terms of Service page live at `/en/terms` and `/fr/terms`
- [ ] Privacy Policy link in footer of every public page
- [ ] No pre-ticked marketing email checkboxes (CASL violation)
- [ ] Parental consent recorded in `consent_records` table on child account creation
- [ ] Email unsubscribe link functional: test `/api/unsubscribe?token=...&type=...`
- [ ] `consent_records` and `audit_logs` tables protected from deletion by RLS policies
- [ ] Soft-delete flow verified: account deletion sets `deletion_requested_at` (30-day grace)
- [ ] Cookie notice / banner in place if using any non-essential cookies (analytics, etc.)
- [ ] PIPEDA privacy officer contact email listed in privacy policy

## Content

- [ ] All curriculum SQL loaded: Explorers, Builders, Developers lessons and quizzes
- [ ] At least one admin account created (`role = 'admin'` in profiles table)
- [ ] At least one test parent + student account created end-to-end
- [ ] Student can complete a lesson, take a quiz, and earn XP
- [ ] Parent can view child progress and manage subscription

## Web / PWA

- [ ] Favicon shows in browser tab (favicon.ico + icon-32.png)
- [ ] `og-image.png` (1200×630) uploaded to `/public/`
- [ ] OG tags verified: paste URL into https://opengraph.xyz
- [ ] PWA manifest valid: open DevTools → Application → Manifest
- [ ] App installable on Android Chrome (no install prompt errors)
- [ ] App installable on iOS Safari (Add to Home Screen shows correct icon + name)
- [ ] `robots.txt` returns 200: `curl https://app.codeshipacademy.com/robots.txt`
- [ ] `sitemap.xml` returns valid XML: `curl https://app.codeshipacademy.com/sitemap.xml`

## Accessibility (AODA / WCAG 2.1 AA)

- [ ] Skip-to-content link works on keyboard (Tab on page load)
- [ ] All images have meaningful `alt` text (or `alt=""` for decorative)
- [ ] Colour contrast ratio ≥ 4.5:1 for normal text (test with axe DevTools)
- [ ] All interactive elements reachable via keyboard Tab order
- [ ] No keyboard traps in modal dialogs

## Performance

- [ ] Lighthouse score ≥ 80 on mobile (Performance, Accessibility, Best Practices, SEO)
- [ ] Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1
- [ ] `npm run build` output shows no unusually large bundles (> 500 kB initial JS)

## Monitoring

- [ ] Error tracking set up (Sentry, Vercel Analytics, or similar)
- [ ] Uptime monitor configured (Better Uptime, Checkly, etc.)
- [ ] Supabase database usage alerts configured (in Supabase dashboard)
- [ ] Stripe payment failure webhook tested (event: `invoice.payment_failed`)

## Go-live

- [ ] DNS TTL lowered to 60s 24 hours before cutover
- [ ] Final smoke test on production URL (login, lesson, quiz, Stripe checkout)
- [ ] Stripe switched from test mode to live mode
- [ ] Team notified of launch
- [ ] DNS TTL restored after launch is stable
