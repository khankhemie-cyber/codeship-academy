import { redirect } from 'next/navigation'

export default async function AddChildRedirect({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  redirect(`/${locale}/dashboard/parent/children`)
}
