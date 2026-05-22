'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useTranslations } from 'next-intl'
import { useRouter } from 'next/navigation'

export default function SettingsPage() {
  const t = useTranslations('settings')
  const router = useRouter()
  const supabase = createClient()

  const [displayName, setDisplayName] = useState('')
  const [currentPassword, setCurrentPassword] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [language, setLanguage] = useState('en')
  const [emailMarketing, setEmailMarketing] = useState(false)
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  const [deleteConfirm, setDeleteConfirm] = useState('')

  async function handleProfileSave(e: React.FormEvent) {
    e.preventDefault()
    setSaving(true)
    setMessage(null)
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return
    const { error } = await supabase
      .from('profiles')
      .update({ display_name: displayName })
      .eq('user_id', user.id)
    setSaving(false)
    setMessage(error ? { type: 'error', text: error.message } : { type: 'success', text: 'Profile updated.' })
  }

  async function handlePasswordChange(e: React.FormEvent) {
    e.preventDefault()
    if (newPassword !== confirmPassword) {
      setMessage({ type: 'error', text: 'Passwords do not match.' })
      return
    }
    setSaving(true)
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    setSaving(false)
    setMessage(error ? { type: 'error', text: error.message } : { type: 'success', text: 'Password updated.' })
    setCurrentPassword('')
    setNewPassword('')
    setConfirmPassword('')
  }

  async function handleDeleteAccount() {
    if (deleteConfirm !== 'DELETE') return
    const res = await fetch('/api/account/delete', { method: 'POST' })
    if (res.ok) {
      await supabase.auth.signOut()
      router.push('/')
    } else {
      setMessage({ type: 'error', text: 'Failed to request account deletion. Please contact support.' })
    }
  }

  return (
    <div className="max-w-2xl space-y-8">
      <h1 className="text-2xl font-bold text-gray-900">{t('title')}</h1>

      {message && (
        <div className={`p-4 rounded-lg text-sm ${message.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'}`}>
          {message.text}
        </div>
      )}

      {/* Profile */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">{t('profile')}</h2>
        <form onSubmit={handleProfileSave} className="space-y-4">
          <div>
            <label className="label">Display Name</label>
            <input
              type="text"
              className="input"
              value={displayName}
              onChange={e => setDisplayName(e.target.value)}
              placeholder="Your display name"
            />
          </div>
          <button type="submit" disabled={saving} className="btn-primary">
            {saving ? 'Saving…' : t('saveChanges')}
          </button>
        </form>
      </section>

      {/* Language */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">{t('language')}</h2>
        <div className="flex gap-4">
          <button
            onClick={() => router.push('/en/dashboard/settings')}
            className={`px-4 py-2 rounded-lg border font-medium ${language === 'en' ? 'bg-brand-navy text-white border-brand-navy' : 'border-gray-200 text-gray-700'}`}
          >
            English
          </button>
          <button
            onClick={() => router.push('/fr/dashboard/settings')}
            className={`px-4 py-2 rounded-lg border font-medium ${language === 'fr' ? 'bg-brand-navy text-white border-brand-navy' : 'border-gray-200 text-gray-700'}`}
          >
            Français
          </button>
        </div>
      </section>

      {/* Email Preferences */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">{t('emailPrefs')}</h2>
        <label className="flex items-start gap-3">
          <input
            type="checkbox"
            checked={emailMarketing}
            onChange={e => setEmailMarketing(e.target.checked)}
            className="mt-1"
          />
          <div>
            <p className="font-medium text-gray-800">Weekly progress digest</p>
            <p className="text-sm text-gray-500">Receive a weekly summary of your child's learning progress.</p>
          </div>
        </label>
        <p className="text-xs text-gray-400 mt-3">
          You can unsubscribe at any time via the link in any email we send. We comply with CASL.
        </p>
      </section>

      {/* Password */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">{t('password')}</h2>
        <form onSubmit={handlePasswordChange} className="space-y-4">
          <div>
            <label className="label">New Password</label>
            <input
              type="password"
              className="input"
              value={newPassword}
              onChange={e => setNewPassword(e.target.value)}
              minLength={8}
              required
            />
          </div>
          <div>
            <label className="label">Confirm New Password</label>
            <input
              type="password"
              className="input"
              value={confirmPassword}
              onChange={e => setConfirmPassword(e.target.value)}
              minLength={8}
              required
            />
          </div>
          <button type="submit" disabled={saving} className="btn-primary">
            Update Password
          </button>
        </form>
      </section>

      {/* Delete Account */}
      <section className="card p-6 border-red-200">
        <h2 className="text-lg font-semibold text-red-700 mb-2">{t('deleteAccount')}</h2>
        <p className="text-sm text-gray-600 mb-4">
          Your account will be scheduled for deletion. You have 30 days to cancel by contacting support.
          All student data will be permanently removed after the grace period.
        </p>
        <div className="space-y-3">
          <div>
            <label className="label text-red-600">Type DELETE to confirm</label>
            <input
              type="text"
              className="input border-red-200 focus:border-red-400"
              value={deleteConfirm}
              onChange={e => setDeleteConfirm(e.target.value)}
              placeholder="DELETE"
            />
          </div>
          <button
            onClick={handleDeleteAccount}
            disabled={deleteConfirm !== 'DELETE'}
            className="px-4 py-2 bg-red-600 text-white rounded-lg font-semibold disabled:opacity-50 disabled:cursor-not-allowed hover:bg-red-700 transition-colors"
          >
            Request Account Deletion
          </button>
        </div>
      </section>
    </div>
  )
}
