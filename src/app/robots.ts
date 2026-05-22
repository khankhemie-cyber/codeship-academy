import type { MetadataRoute } from 'next'

export default function robots(): MetadataRoute.Robots {
  const base = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'
  return {
    rules: [
      {
        userAgent: '*',
        allow: ['/', '/en/', '/fr/', '/en/privacy', '/fr/privacy', '/en/terms', '/fr/terms'],
        disallow: ['/en/dashboard/', '/fr/dashboard/', '/api/'],
      },
    ],
    sitemap: `${base}/sitemap.xml`,
    host: base,
  }
}
