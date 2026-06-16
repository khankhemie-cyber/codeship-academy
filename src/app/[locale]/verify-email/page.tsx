import Link from 'next/link'

export const dynamic = 'force-dynamic'

export default async function VerifyEmailPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params

  return (
    <div className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="max-w-md w-full text-center">
        <div className="text-6xl mb-6">📧</div>
        <h1 className="text-2xl font-extrabold text-brand-navy mb-4">Check your inbox!</h1>
        <p className="text-gray-600 mb-6">
          We&apos;ve sent a verification link to your email address. Click the link to activate your account and start your free trial.
        </p>
        <p className="text-sm text-gray-500 mb-8">
          Didn&apos;t receive it? Check your spam folder or contact{' '}
          <a href="mailto:admin@codeshipacademy.com" className="text-brand-navy underline">
            admin@codeshipacademy.com
          </a>
        </p>
        <Link href={`/${locale}/login`} className="btn-secondary">
          Back to Login
        </Link>
      </div>
    </div>
  )
}
