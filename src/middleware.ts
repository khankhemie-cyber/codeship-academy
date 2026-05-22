import createMiddleware from 'next-intl/middleware'
import { type NextRequest, NextResponse } from 'next/server'
import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { locales } from './i18n'

const intlMiddleware = createMiddleware({
  locales,
  defaultLocale: 'en',
  localePrefix: 'always',
})

const protectedRoutes = ['/dashboard', '/api/ai', '/api/stripe', '/api/account', '/api/students', '/api/classes', '/api/schools']
const publicApiRoutes = ['/api/stripe/webhook', '/api/unsubscribe', '/api/emails/weekly-digest']

export async function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname

  // Strip locale prefix to check the actual path
  const pathnameWithoutLocale = locales.reduce((p, locale) => {
    return p.startsWith(`/${locale}`) ? p.slice(locale.length + 1) || '/' : p
  }, pathname)

  // Allow public API routes
  if (publicApiRoutes.some((route) => pathname.startsWith(route))) {
    return NextResponse.next()
  }

  // Check if this is a protected dashboard route
  const isDashboardRoute = locales.some((locale) =>
    pathname.startsWith(`/${locale}/dashboard`)
  )
  const isProtectedApi = protectedRoutes.some((route) =>
    pathname.startsWith(route) && !publicApiRoutes.some((pub) => pathname.startsWith(pub))
  )

  if (isDashboardRoute || isProtectedApi) {
    const response = NextResponse.next()

    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() {
            return request.cookies.getAll()
          },
          setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
            cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
            cookiesToSet.forEach(({ name, value, options }) =>
              response.cookies.set(name, value, options)
            )
          },
        },
      }
    )

    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      const locale = locales.find((l) => pathname.startsWith(`/${l}`)) ?? 'en'
      const loginUrl = new URL(`/${locale}/login`, request.url)
      loginUrl.searchParams.set('redirect', pathname)
      return NextResponse.redirect(loginUrl)
    }

    return response
  }

  return intlMiddleware(request)
}

export const config = {
  matcher: ['/((?!_next|_vercel|.*\\..*).*)'],
}
