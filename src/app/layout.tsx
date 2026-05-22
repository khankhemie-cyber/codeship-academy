import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'CODEship Academy',
  description: 'AI-powered K–8 coding education. DREAM. CODE. ACHIEVE.',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return children
}
