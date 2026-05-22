import { NextIntlClientProvider } from 'next-intl'
import { getMessages } from 'next-intl/server'
import { notFound } from 'next/navigation'
import { locales, type Locale } from '@/i18n'
import type { Metadata } from 'next'

export const dynamic = 'force-dynamic'

export async function generateMetadata({
  params,
}: {
  params: Promise<{ locale: string }>
}): Promise<Metadata> {
  const { locale } = await params
  const isFr = locale === 'fr'
  return {
    title: 'CODEship Academy',
    description: isFr
      ? 'RÊVER. CODER. RÉUSSIR. — La plateforme d\'apprentissage du codage pour les enfants K–8.'
      : 'DREAM. CODE. ACHIEVE. — AI-powered K–8 coding education platform.',
    icons: { icon: '/favicon.ico' },
  }
}

export default async function LocaleLayout({
  children,
  params,
}: {
  children: React.ReactNode
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params

  if (!locales.includes(locale as Locale)) notFound()

  const messages = await getMessages()

  return (
    <html lang={locale}>
      <body>
        <a
          className="sr-only focus:not-sr-only focus:absolute focus:top-0 focus:left-0 focus:z-50 focus:bg-brand-gold focus:text-brand-navy focus:px-4 focus:py-2 focus:font-bold"
          href="#main"
        >
          {locale === 'fr' ? 'Passer au contenu principal' : 'Skip to main content'}
        </a>
        <NextIntlClientProvider messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
