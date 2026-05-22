import { getTranslations } from 'next-intl/server'
import Link from 'next/link'

export default async function UnsubscribedPage({ params }: { params: { locale: string } }) {
  return (
    <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="card max-w-md w-full p-8 text-center">
        <div className="text-5xl mb-4">✉️</div>
        <h1 className="text-2xl font-bold text-gray-900 mb-2">You&apos;ve been unsubscribed</h1>
        <p className="text-gray-600 mb-6">
          You will no longer receive marketing emails from CODEship Academy.
          Transactional emails (account security, billing) may still be sent as required.
        </p>
        <p className="text-sm text-gray-400 mb-6">
          Changed your mind? You can re-enable email preferences in your account settings.
        </p>
        <Link href={`/${params.locale}`} className="btn-primary">
          Return to Home
        </Link>
      </div>
    </main>
  )
}
