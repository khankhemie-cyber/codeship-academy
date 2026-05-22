'use client'

import { useState } from 'react'
import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import {
  LayoutDashboard, BookOpen, Code2, Trophy, BarChart3, Users,
  Settings, Bell, LogOut, Menu, X, GraduationCap, School,
  ClipboardList, Star, FileText, Home, Swords
} from 'lucide-react'

interface NavItem {
  href: string
  label: string
  icon: React.ReactNode
}

interface DashboardShellProps {
  role: 'parent' | 'teacher' | 'student' | 'admin'
  userName: string
  avatarEmoji?: string
  children: React.ReactNode
  locale?: string
}

function getNavItems(role: string, locale: string): NavItem[] {
  const base = `/${locale}/dashboard`
  const maps: Record<string, NavItem[]> = {
    parent: [
      { href: `${base}/parent`, label: 'Overview', icon: <Home size={18} /> },
      { href: `${base}/parent/children`, label: 'My Children', icon: <Users size={18} /> },
      { href: `${base}/parent/assessment`, label: 'AI Assessment', icon: <GraduationCap size={18} /> },
      { href: `${base}/parent/planner`, label: 'Learning Plan', icon: <ClipboardList size={18} /> },
      { href: `${base}/parent/progress`, label: 'Progress', icon: <BarChart3 size={18} /> },
      { href: `${base}/parent/subscription`, label: 'Subscription', icon: <Star size={18} /> },
      { href: `${base}/settings`, label: 'Settings', icon: <Settings size={18} /> },
    ],
    student: [
      { href: `${base}/student`, label: "Today's Task", icon: <Home size={18} /> },
      { href: `${base}/curriculum`, label: 'Learn', icon: <BookOpen size={18} /> },
      { href: `${base}/code-lab`, label: 'Code Lab', icon: <Code2 size={18} /> },
      { href: `${base}/achievements`, label: 'Achievements', icon: <Trophy size={18} /> },
      { href: `${base}/leaderboard`, label: 'Leaderboard', icon: <Swords size={18} /> },
      { href: `${base}/certificates`, label: 'Certificates', icon: <FileText size={18} /> },
      { href: `${base}/settings`, label: 'Settings', icon: <Settings size={18} /> },
    ],
    teacher: [
      { href: `${base}/teacher`, label: 'Overview', icon: <Home size={18} /> },
      { href: `${base}/classes`, label: 'My Classes', icon: <Users size={18} /> },
      { href: `${base}/reports`, label: 'Reports', icon: <BarChart3 size={18} /> },
      { href: `${base}/school`, label: 'School Portal', icon: <School size={18} /> },
      { href: `${base}/settings`, label: 'Settings', icon: <Settings size={18} /> },
    ],
    admin: [
      { href: `${base}/admin`, label: 'Overview', icon: <Home size={18} /> },
      { href: `${base}/admin/users`, label: 'Users', icon: <Users size={18} /> },
      { href: `${base}/admin/analytics`, label: 'Analytics', icon: <BarChart3 size={18} /> },
      { href: `${base}/admin/curriculum`, label: 'Curriculum', icon: <BookOpen size={18} /> },
      { href: `${base}/admin/audit`, label: 'Audit Log', icon: <ClipboardList size={18} /> },
      { href: `${base}/admin/subscriptions`, label: 'Subscriptions', icon: <Star size={18} /> },
      { href: `${base}/settings`, label: 'Settings', icon: <Settings size={18} /> },
    ],
  }
  return maps[role] ?? maps.parent
}

export default function DashboardShell({ role, userName, avatarEmoji = '🚀', children, locale = 'en' }: DashboardShellProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const pathname = usePathname()
  const router = useRouter()
  const navItems = getNavItems(role, locale)

  async function handleLogout() {
    const supabase = createClient()
    await supabase.auth.signOut()
    router.push(`/${locale}/login`)
  }

  const sidebar = (
    <aside className="flex flex-col h-full bg-brand-navy text-white">
      {/* Logo */}
      <div className="px-6 py-5 border-b border-brand-mid">
        <Link href={`/${locale}`} className="font-extrabold text-lg text-brand-gold">
          CODEship Academy
        </Link>
      </div>

      {/* User info */}
      <div className="px-6 py-4 border-b border-brand-mid">
        <div className="flex items-center gap-3">
          <div className="text-2xl">{avatarEmoji}</div>
          <div>
            <div className="font-bold text-sm truncate max-w-[140px]">{userName}</div>
            <div className="text-xs text-gray-400 capitalize">{role}</div>
          </div>
        </div>
      </div>

      {/* Nav */}
      <nav className="flex-1 px-3 py-4 overflow-y-auto" aria-label="Dashboard navigation">
        {navItems.map((item) => {
          const isActive = pathname === item.href || pathname.startsWith(item.href + '/')
          return (
            <Link
              key={item.href}
              href={item.href}
              onClick={() => setSidebarOpen(false)}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-xl mb-1 text-sm font-semibold transition-colors ${
                isActive
                  ? 'bg-brand-gold text-brand-navy'
                  : 'text-gray-300 hover:bg-brand-mid hover:text-white'
              }`}
              aria-current={isActive ? 'page' : undefined}
            >
              {item.icon}
              {item.label}
            </Link>
          )
        })}
      </nav>

      {/* Logout */}
      <div className="px-3 pb-6">
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-gray-400 hover:bg-brand-mid hover:text-white transition-colors"
        >
          <LogOut size={18} />
          Sign out
        </button>
      </div>
    </aside>
  )

  return (
    <div className="flex h-screen overflow-hidden bg-brand-light">
      {/* Desktop sidebar */}
      <div className="hidden md:flex md:w-60 md:flex-shrink-0 flex-col">
        {sidebar}
      </div>

      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 md:hidden"
          aria-hidden="true"
          onClick={() => setSidebarOpen(false)}
        >
          <div className="absolute inset-0 bg-black opacity-50" />
        </div>
      )}
      <div
        className={`fixed inset-y-0 left-0 z-50 w-60 flex flex-col transform transition-transform md:hidden ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {sidebar}
      </div>

      {/* Main content */}
      <div className="flex flex-col flex-1 overflow-hidden">
        {/* Top bar */}
        <header className="bg-white border-b border-gray-200 px-4 md:px-6 py-3 flex items-center justify-between">
          <button
            className="md:hidden p-2 rounded-lg hover:bg-gray-100"
            onClick={() => setSidebarOpen(!sidebarOpen)}
            aria-label={sidebarOpen ? 'Close menu' : 'Open menu'}
          >
            {sidebarOpen ? <X size={20} /> : <Menu size={20} />}
          </button>

          <div className="flex-1 md:flex-none" />

          <div className="flex items-center gap-3">
            <Link
              href={`/${locale}/dashboard/notifications`}
              className="p-2 rounded-lg hover:bg-gray-100 relative"
              aria-label="Notifications"
            >
              <Bell size={20} className="text-gray-600" />
            </Link>
            <div className="text-lg">{avatarEmoji}</div>
          </div>
        </header>

        {/* Page content */}
        <main id="main" className="flex-1 overflow-y-auto p-4 md:p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
