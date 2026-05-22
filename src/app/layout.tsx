import type { Metadata, Viewport } from 'next'
import './globals.css'

const APP_URL = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'

export const metadata: Metadata = {
  metadataBase: new URL(APP_URL),
  title: {
    default: 'CODEship Academy — K–8 Coding Education',
    template: '%s | CODEship Academy',
  },
  description: 'AI-powered K–8 coding education for Canadian families. DREAM. CODE. ACHIEVE.',
  keywords: ['coding for kids', 'k-8 education', 'learn to code', 'Scratch', 'JavaScript', 'Ontario'],
  authors: [{ name: 'CODEship Academy', url: APP_URL }],
  creator: 'CODEship Academy',
  publisher: 'CODEship Academy',
  applicationName: 'CODEship Academy',
  generator: 'Next.js',
  referrer: 'strict-origin-when-cross-origin',
  robots: { index: true, follow: true, googleBot: { index: true, follow: true } },
  openGraph: {
    type: 'website',
    locale: 'en_CA',
    alternateLocale: 'fr_CA',
    url: APP_URL,
    siteName: 'CODEship Academy',
    title: 'CODEship Academy — K–8 Coding Education',
    description: 'AI-powered K–8 coding education for Canadian families.',
    images: [{ url: '/og-image.png', width: 1200, height: 630, alt: 'CODEship Academy' }],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'CODEship Academy — K–8 Coding Education',
    description: 'AI-powered K–8 coding education for Canadian families.',
    images: ['/og-image.png'],
  },
  icons: {
    icon: [
      { url: '/favicon.ico', sizes: 'any' },
      { url: '/icons/icon-32.png', sizes: '32x32', type: 'image/png' },
      { url: '/icons/icon-192.png', sizes: '192x192', type: 'image/png' },
    ],
    apple: '/icons/apple-touch-icon.png',
    shortcut: '/favicon.ico',
  },
  manifest: '/manifest.webmanifest',
}

export const viewport: Viewport = {
  themeColor: '#0a1628',
  colorScheme: 'light',
  width: 'device-width',
  initialScale: 1,
  maximumScale: 5,
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return children
}
