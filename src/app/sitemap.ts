import type { MetadataRoute } from 'next'

const base = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'

const publicRoutes = ['', '/privacy', '/terms', '/signup', '/login']

export default function sitemap(): MetadataRoute.Sitemap {
  const entries: MetadataRoute.Sitemap = []

  for (const locale of ['en', 'fr']) {
    for (const route of publicRoutes) {
      entries.push({
        url: `${base}/${locale}${route}`,
        lastModified: new Date(),
        changeFrequency: route === '' ? 'weekly' : 'monthly',
        priority: route === '' ? 1.0 : 0.7,
        alternates: {
          languages: {
            en: `${base}/en${route}`,
            fr: `${base}/fr${route}`,
          },
        },
      })
    }
  }

  return entries
}
