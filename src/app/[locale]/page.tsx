import Link from 'next/link'

const levels = [
  {
    emoji: '🌱',
    name: 'Explorers',
    grades: 'K–1',
    ages: 'Ages 6–7',
    desc: 'Block coding, visual logic, and computational thinking',
    color: 'bg-green-50 border-green-200',
    badge: 'bg-green-100 text-green-800',
  },
  {
    emoji: '🏗️',
    name: 'Builders',
    grades: 'Gr 2–3',
    ages: 'Ages 8–9',
    desc: 'HTML, CSS, and Scratch — build real websites',
    color: 'bg-blue-50 border-blue-200',
    badge: 'bg-blue-100 text-blue-800',
  },
  {
    emoji: '💻',
    name: 'Developers',
    grades: 'Gr 4–8',
    ages: 'Ages 10–16',
    desc: 'JavaScript, APIs, React, Python intro, and extension projects',
    color: 'bg-purple-50 border-purple-200',
    badge: 'bg-purple-100 text-purple-800',
  },
]

const features = [
  { icon: '🤖', title: 'AI Tutor', desc: 'Personalised hints and guidance — never the answer outright' },
  { icon: '💻', title: 'Code Lab', desc: 'In-browser coding: blocks for K–3, full editor for 4–8' },
  { icon: '🏅', title: 'Certificates', desc: 'Shareable completion certificates for every level' },
  { icon: '🇨🇦 🇫🇷', title: 'Bilingual', desc: 'Full English and French support for Ontario families' },
  { icon: '📊', title: 'Parent Dashboard', desc: 'Weekly progress digests and AI-generated learning plans' },
  { icon: '🏫', title: 'School Portal', desc: 'Workshop booking, attendance tracking, impact reports' },
]

export default async function LandingPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const otherLocale = locale === 'fr' ? 'en' : 'fr'

  return (
    <div className="min-h-screen bg-white">
      {/* Nav */}
      <nav className="bg-brand-navy text-white px-6 py-4 flex items-center justify-between">
        <span className="font-extrabold text-xl text-brand-gold">CODEship Academy</span>
        <div className="flex items-center gap-4">
          <Link href={`/${locale}/login`} className="text-sm hover:text-brand-gold transition-colors">Login</Link>
          <Link href={`/${locale}/signup`} className="btn-primary text-sm py-2 px-4">Start Free Trial</Link>
        </div>
      </nav>

      <main id="main">
        {/* Hero */}
        <section className="bg-brand-navy text-white py-24 px-6 text-center">
          <h1 className="text-5xl md:text-7xl font-extrabold mb-4">
            <span className="text-brand-gold">DREAM.</span> CODE.{' '}
            <span className="text-brand-gold">ACHIEVE.</span>
          </h1>
          <p className="text-xl text-gray-300 max-w-2xl mx-auto mb-10">
            AI-powered K–8 coding education that inspires kids to build real things.
            Start with blocks, end with full-stack apps.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href={`/${locale}/signup`} className="btn-primary text-lg px-8 py-4">
              Start Free Trial — 14 Days Free
            </Link>
            <Link
              href="#schools"
              className="bg-transparent border-2 border-white text-white font-bold px-8 py-4 rounded-xl hover:bg-white hover:text-brand-navy transition-colors"
            >
              For Schools
            </Link>
          </div>
          <p className="mt-4 text-sm text-gray-400">No credit card required. Cancel anytime.</p>
        </section>

        {/* Levels */}
        <section className="py-20 px-6 max-w-6xl mx-auto">
          <h2 className="text-3xl font-extrabold text-brand-navy text-center mb-4">
            Launch Curriculum for Every Child
          </h2>
          <p className="text-center text-gray-600 mb-12 max-w-xl mx-auto">
            AI assessment places every student at the right level, then guides them through a structured curriculum built for Canada.
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {levels.map((level) => (
              <div key={level.name} className={`rounded-2xl border-2 p-6 ${level.color}`}>
                <div className="text-4xl mb-3">{level.emoji}</div>
                <h3 className="font-extrabold text-xl text-brand-navy">{level.name}</h3>
                <div className={`badge ${level.badge} mt-1 mb-3`}>{level.grades} · {level.ages}</div>
                <p className="text-gray-700 text-sm">{level.desc}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Features */}
        <section className="py-20 px-6 bg-brand-light">
          <div className="max-w-6xl mx-auto">
            <h2 className="text-3xl font-extrabold text-brand-navy text-center mb-12">
              Everything Kids Need to Become Coders
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {features.map((f) => (
                <div key={f.title} className="card">
                  <div className="text-4xl mb-3">{f.icon}</div>
                  <h3 className="font-bold text-lg text-brand-navy mb-2">{f.title}</h3>
                  <p className="text-gray-600">{f.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Pricing */}
        <section className="py-20 px-6 max-w-5xl mx-auto" id="pricing">
          <h2 className="text-3xl font-extrabold text-brand-navy text-center mb-4">Simple, Fair Pricing</h2>
          <p className="text-center text-gray-600 mb-12">All plans include a 14-day free trial. No credit card required.</p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              { name: 'Personal', price: '$19/mo', desc: 'One child, all features', highlight: false },
              { name: 'Family', price: '$29/mo', desc: 'Up to 4 children', highlight: true },
              { name: 'Annual', price: '$149/yr', desc: 'Save over $80 per year', highlight: false },
            ].map((plan) => (
              <div
                key={plan.name}
                className={`rounded-2xl p-8 text-center ${plan.highlight ? 'bg-brand-navy text-white' : 'bg-white border-2 border-gray-200'}`}
              >
                <h3 className="font-extrabold text-xl mb-2">{plan.name}</h3>
                <div className="text-3xl font-extrabold my-4 text-brand-gold">{plan.price}</div>
                <p className={plan.highlight ? 'text-gray-300' : 'text-gray-600'}>{plan.desc}</p>
                <Link
                  href={`/${locale}/signup`}
                  className={`block mt-6 font-bold py-3 px-6 rounded-xl transition-colors ${plan.highlight ? 'bg-brand-gold text-brand-navy hover:opacity-90' : 'bg-brand-navy text-white hover:bg-brand-mid'}`}
                >
                  Start Free Trial
                </Link>
              </div>
            ))}
          </div>
        </section>

        {/* Schools CTA */}
        <section className="py-20 px-6 bg-brand-navy text-white text-center" id="schools">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl font-extrabold mb-4">Bring CODEship Academy to Your School</h2>
            <p className="text-gray-300 mb-8">
              90-minute enrichment workshops at $280/class or $950/full-day.
              Impact reports included. AODA-compliant. Bilingual EN/FR.
            </p>
            <Link href={`/${locale}/signup?type=teacher`} className="btn-primary text-lg px-8 py-4">
              Book a Workshop
            </Link>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-brand-dark text-gray-400 py-10 px-6">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row justify-between items-start gap-6">
          <div>
            <div className="font-extrabold text-white text-lg mb-1">CODEship Academy</div>
            <div className="text-sm">21 Simcoe St S, Oshawa, ON L1H 4G2</div>
            <div className="text-sm">admin@codeshipacademy.com</div>
          </div>
          <div className="flex flex-wrap gap-6 text-sm">
            <Link href={`/${locale}/privacy`} className="hover:text-white">Privacy Policy</Link>
            <Link href={`/${locale}/terms`} className="hover:text-white">Terms of Service</Link>
            <Link href={`/${otherLocale}`} className="hover:text-white">
              {locale === 'fr' ? 'English' : 'Français'}
            </Link>
          </div>
        </div>
        <div className="max-w-6xl mx-auto mt-6 pt-6 border-t border-gray-700 text-xs text-gray-500">
          © 2026 CODEship Academy Inc. PIPEDA/CASL compliant. AODA accessible. Ontario, Canada.
        </div>
      </footer>
    </div>
  )
}
