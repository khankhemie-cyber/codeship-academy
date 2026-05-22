import Link from 'next/link'

export default async function TermsPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const isFr = locale === 'fr'

  return (
    <div className="min-h-screen bg-white">
      <nav className="bg-brand-navy px-6 py-4">
        <Link href={`/${locale}`} className="font-extrabold text-brand-gold text-lg">CODEship Academy</Link>
      </nav>

      <main id="main" className="max-w-4xl mx-auto px-6 py-12">
        <h1 className="text-3xl font-extrabold text-brand-navy mb-2">
          {isFr ? 'Conditions d\'utilisation' : 'Terms of Service'}
        </h1>
        <p className="text-gray-500 mb-8">{isFr ? 'Dernière mise à jour: 15 janvier 2026' : 'Last updated: January 15, 2026'}</p>

        <div className="prose max-w-none text-gray-700 space-y-8">
          <section>
            <h2 className="text-xl font-bold text-brand-navy">1. {isFr ? 'Acceptation des conditions' : 'Acceptance of Terms'}</h2>
            <p>
              {isFr
                ? 'En accédant à CODEship Academy, vous acceptez ces conditions d\'utilisation. Vous devez avoir 18 ans ou plus pour créer un compte. Les comptes pour enfants de moins de 13 ans nécessitent le consentement parental vérifiable. En utilisant la plateforme, les enseignants et les parents acceptent expressément ces conditions lors de l\'inscription.'
                : 'By accessing CODEship Academy, you agree to these Terms of Service. You must be 18 or older to create an account. Accounts for children under 13 require verifiable parental consent. Teachers and parents expressly accept these terms at signup.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">2. {isFr ? 'Comptes utilisateurs' : 'User Accounts'}</h2>
            <ul className="list-disc pl-6 space-y-2">
              <li>{isFr ? 'Les parents sont légalement responsables de l\'utilisation de la plateforme par leurs enfants.' : 'Parents are legally responsible for their child\'s use of the platform.'}</li>
              <li>{isFr ? 'Les enseignants sont responsables des élèves dans leurs classes.' : 'Teachers are responsible for students in their classes.'}</li>
              <li>{isFr ? 'Les comptes d\'élèves sont créés par les parents (pas via l\'inscription directe).' : 'Student accounts are created by parents (not via direct signup).'}</li>
              <li>{isFr ? 'Vous êtes responsable de maintenir la sécurité de votre mot de passe.' : 'You are responsible for maintaining the security of your password.'}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">3. {isFr ? 'Utilisation acceptable' : 'Acceptable Use'}</h2>
            <p>{isFr ? 'Vous vous engagez à ne pas:' : 'You agree not to:'}</p>
            <ul className="list-disc pl-6 space-y-1">
              <li>{isFr ? 'Soumettre du contenu nuisible, abusif, discriminatoire ou illégal' : 'Submit harmful, abusive, discriminatory, or illegal content'}</li>
              <li>{isFr ? 'Tenter d\'accéder aux données d\'autres utilisateurs' : 'Attempt to access other users\' data'}</li>
              <li>{isFr ? 'Contourner les mesures de sécurité' : 'Circumvent security measures'}</li>
              <li>{isFr ? 'Utiliser la plateforme à des fins commerciales non autorisées' : 'Use the platform for unauthorized commercial purposes'}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">4. {isFr ? 'Propriété intellectuelle' : 'Intellectual Property'}</h2>
            <p>
              {isFr
                ? 'CODEship Academy Inc. est propriétaire du programme d\'études, de la marque et de la technologie sous-jacente. Les élèves sont propriétaires du code de leurs projets qu\'ils créent sur la plateforme. Le contenu éducatif ne peut pas être reproduit sans autorisation écrite.'
                : 'CODEship Academy Inc. owns the curriculum, brand, and underlying technology. Students own the project code they create on the platform. Educational content may not be reproduced without written permission.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">5. {isFr ? 'Contenu de l\'IA' : 'AI-Generated Content'}</h2>
            <p>
              {isFr
                ? 'Le tuteur IA fournit des conseils éducatifs uniquement. Il ne fournit pas de conseils professionnels. CODEship Academy n\'est pas responsable des erreurs dans les réponses de l\'IA. Le tuteur est conçu pour guider, pas pour donner des réponses directes.'
                : 'The AI tutor provides educational guidance only. It does not provide professional advice. CODEship Academy is not responsible for errors in AI responses. The tutor is designed to guide, not to give direct answers.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">6. {isFr ? 'Facturation et paiements' : 'Billing and Payments'}</h2>
            <ul className="list-disc pl-6 space-y-2">
              <li>{isFr ? 'Essai gratuit de 14 jours — aucune carte de crédit requise.' : '14-day free trial — no credit card required.'}</li>
              <li>{isFr ? 'Les abonnements sont facturés de façon récurrente (mensuelle ou annuelle).' : 'Subscriptions are billed on a recurring basis (monthly or annually).'}</li>
              <li>{isFr ? 'Vous pouvez annuler à tout moment via le portail de facturation.' : 'You may cancel at any time via the billing portal.'}</li>
              <li>{isFr ? 'Aucun remboursement pour les périodes partielles, sauf obligation légale.' : 'No refunds for partial periods unless required by law.'}</li>
              <li>{isFr ? 'Les prix sont en dollars canadiens (CAD) et peuvent être modifiés avec un préavis de 30 jours.' : 'Prices are in Canadian dollars (CAD) and may change with 30 days notice.'}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">7. {isFr ? 'Limitation de responsabilité' : 'Limitation of Liability'}</h2>
            <p>
              {isFr
                ? 'Dans les limites permises par la loi ontarienne, CODEship Academy Inc. ne sera pas responsable des dommages indirects, accessoires ou consécutifs résultant de votre utilisation de la plateforme. Notre responsabilité totale n\'excédera pas le montant payé au cours des 12 derniers mois.'
                : 'To the maximum extent permitted by Ontario law, CODEship Academy Inc. shall not be liable for indirect, incidental, or consequential damages arising from your use of the platform. Our total liability shall not exceed the amount paid in the last 12 months.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">8. {isFr ? 'Droit applicable et juridiction' : 'Governing Law and Jurisdiction'}</h2>
            <p>
              {isFr
                ? 'Ces conditions sont régies par les lois de la province d\'Ontario et les lois du Canada. Les litiges seront résolus devant les tribunaux d\'Ontario. Les parties acceptent la juridiction exclusive des tribunaux d\'Ontario pour tout litige découlant de ces conditions.'
                : 'These terms are governed by the laws of the Province of Ontario and the laws of Canada. Disputes will be resolved in Ontario courts. The parties consent to the exclusive jurisdiction of Ontario courts for any dispute arising from these terms.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">9. {isFr ? 'Modifications' : 'Changes to Terms'}</h2>
            <p>
              {isFr
                ? 'Nous vous notifierons par email au moins 30 jours avant toute modification importante de ces conditions. L\'utilisation continue de la plateforme après notification constitue l\'acceptation des nouvelles conditions.'
                : 'We will notify you by email at least 30 days before any material changes to these terms. Continued use of the platform after notification constitutes acceptance of the new terms.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">10. {isFr ? 'Contact' : 'Contact'}</h2>
            <p>
              <strong>CODEship Academy Inc.</strong><br />
              21 Simcoe St S, Oshawa, ON L1H 4G2<br />
              <a href="mailto:admin@codeshipacademy.com" className="text-brand-navy underline">admin@codeshipacademy.com</a>
            </p>
          </section>
        </div>
      </main>
    </div>
  )
}
