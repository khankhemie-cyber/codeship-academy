import Link from 'next/link'

export default async function PrivacyPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const isFr = locale === 'fr'

  return (
    <div className="min-h-screen bg-white">
      <nav className="bg-brand-navy px-6 py-4">
        <Link href={`/${locale}`} className="font-extrabold text-brand-gold text-lg">CODEship Academy</Link>
      </nav>

      <main id="main" className="max-w-4xl mx-auto px-6 py-12">
        <h1 className="text-3xl font-extrabold text-brand-navy mb-2">
          {isFr ? 'Politique de confidentialité' : 'Privacy Policy'}
        </h1>
        <p className="text-gray-500 mb-8">
          {isFr ? 'Dernière mise à jour: 15 janvier 2026' : 'Last updated: January 15, 2026'}
        </p>

        <div className="prose max-w-none text-gray-700 space-y-8">
          <section>
            <h2 className="text-xl font-bold text-brand-navy">1. {isFr ? 'Qui nous sommes' : 'Who We Are'}</h2>
            <p>
              {isFr
                ? 'CODEship Academy Inc. (« nous », « notre ») exploite la plateforme d\'apprentissage du codage CODEship Academy. Notre siège social est au 21 Simcoe St S, Oshawa, ON L1H 4G2, Canada. Contactez-nous à admin@codeshipacademy.com.'
                : 'CODEship Academy Inc. ("we", "our") operates the CODEship Academy coding education platform. Our registered office is at 21 Simcoe St S, Oshawa, ON L1H 4G2, Canada. Contact us at admin@codeshipacademy.com.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">2. {isFr ? 'Données collectées' : 'Data We Collect'}</h2>
            <p>{isFr ? 'Nous collectons uniquement ce dont nous avons besoin pour fournir le service éducatif:' : 'We collect only what is necessary to provide the educational service:'}</p>
            <ul className="list-disc pl-6 space-y-1">
              <li>{isFr ? 'Nom, adresse email, et rôle (parent, enseignant, ou élève)' : 'Name, email address, and role (parent, teacher, or student)'}</li>
              <li>{isFr ? 'Tranche d\'âge et niveau scolaire (pour les élèves)' : 'Age range and grade level (for students)'}</li>
              <li>{isFr ? 'Progrès d\'apprentissage: leçons complétées, scores de quiz, projets soumis' : 'Learning progress: completed lessons, quiz scores, submitted projects'}</li>
              <li>{isFr ? 'Préférences de langue (français ou anglais)' : 'Language preferences (French or English)'}</li>
            </ul>
            <p className="mt-4 font-semibold text-red-700">
              {isFr
                ? 'Nous ne collectons PAS: date de naissance complète (seulement la tranche d\'âge), adresse domicile, nom d\'école précis des élèves, photos d\'élèves.'
                : 'We do NOT collect: full birthdates (age band only), home addresses, precise school names from students, or photos of students.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">3. {isFr ? 'Données des enfants et consentement parental' : 'Children\'s Data and Parental Consent'}</h2>
            <p>
              {isFr
                ? 'Les élèves de moins de 13 ans ne peuvent être inscrits que par un parent ou tuteur. Nous exigeons un consentement parental exprès avant de créer tout compte d\'élève. Ce consentement est enregistré avec l\'horodatage, l\'adresse IP et la méthode de consentement pour les besoins légaux.'
                : 'Students under 13 may only be registered by a parent or guardian. We require express parental consent before creating any student account. This consent is recorded with timestamp, IP address, and consent method for legal purposes.'}
            </p>
            <p className="mt-2">
              {isFr
                ? 'Les conversations avec le tuteur IA ne sont pas stockées de façon permanente. Elles existent uniquement pour la durée de la session.'
                : 'AI tutor conversations are not permanently stored. They exist only for the duration of the session.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">4. {isFr ? 'Traitement par l\'IA' : 'AI Processing'}</h2>
            <p>
              {isFr
                ? 'CODEship Academy utilise l\'IA Claude d\'Anthropic pour fournir des évaluations personnalisées, des plans d\'apprentissage et l\'aide tutorielle. Les données d\'apprentissage agrégées (niveau, progression de leçon) sont envoyées à Anthropic pour générer des conseils adaptés à l\'âge. Aucune information personnellement identifiable n\'est incluse dans les requêtes IA au-delà du niveau et de la progression.'
                : 'CODEship Academy uses Anthropic\'s Claude AI to provide personalised assessments, learning plans, and tutoring assistance. Aggregated learning data (level, lesson progress) is sent to Anthropic to generate age-appropriate guidance. No personally identifiable information is included in AI requests beyond level and progress data.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">5. {isFr ? 'Tiers' : 'Third Parties'}</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-sm border-collapse border border-gray-200">
                <thead>
                  <tr className="bg-gray-50">
                    <th className="border border-gray-200 px-3 py-2 text-left">{isFr ? 'Service' : 'Service'}</th>
                    <th className="border border-gray-200 px-3 py-2 text-left">{isFr ? 'Objectif' : 'Purpose'}</th>
                    <th className="border border-gray-200 px-3 py-2 text-left">{isFr ? 'Données partagées' : 'Data Shared'}</th>
                  </tr>
                </thead>
                <tbody>
                  {[
                    ['Stripe', isFr ? 'Paiements' : 'Billing', isFr ? 'Email, nom (aucune donnée de carte)' : 'Email, name (no card data)'],
                    ['Resend', isFr ? 'Emails' : 'Emails', isFr ? 'Email, nom' : 'Email, name'],
                    ['Supabase', isFr ? 'Base de données et authentification' : 'Database and auth', isFr ? 'Toutes les données de compte' : 'All account data'],
                    ['Anthropic', 'AI', isFr ? 'Données d\'apprentissage anonymisées' : 'Anonymised learning data'],
                    ['Vercel', isFr ? 'Hébergement' : 'Hosting', isFr ? 'Données de trafic' : 'Traffic data'],
                  ].map(([service, purpose, data]) => (
                    <tr key={service}>
                      <td className="border border-gray-200 px-3 py-2 font-semibold">{service}</td>
                      <td className="border border-gray-200 px-3 py-2">{purpose}</td>
                      <td className="border border-gray-200 px-3 py-2">{data}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">6. {isFr ? 'Conservation des données' : 'Data Retention'}</h2>
            <ul className="list-disc pl-6 space-y-1">
              <li>{isFr ? 'Comptes actifs: conservation indéfinie' : 'Active accounts: indefinitely'}</li>
              <li>{isFr ? 'Abonnements annulés: 90 jours, puis suppression douce' : 'Cancelled subscriptions: 90 days, then soft-delete'}</li>
              <li>{isFr ? 'Comptes supprimés: 30 jours (pour les litiges), puis purge' : 'Deleted accounts: 30 days (for disputes), then purge'}</li>
              <li>{isFr ? 'Journaux d\'audit: 2 ans minimum (exigence légale)' : 'Audit logs: 2 years minimum (legal requirement)'}</li>
              <li>{isFr ? 'Réponses aux quiz: roulement de 12 mois' : 'Quiz attempt answers: 12 months rolling'}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">7. {isFr ? 'Vos droits' : 'Your Rights'}</h2>
            <p>
              {isFr
                ? 'En vertu de la LPRPDE et de la loi C-27 (à venir), vous avez le droit d\'accéder, corriger et supprimer vos données. Pour exercer ces droits, contactez admin@codeshipacademy.com.'
                : 'Under PIPEDA and Bill C-27 (forthcoming), you have the right to access, correct, and delete your data. To exercise these rights, contact admin@codeshipacademy.com.'}
            </p>
            <p className="mt-2">
              {isFr
                ? 'Les demandes de suppression de compte seront traitées dans les 30 jours. Les journaux d\'audit sont conservés conformément aux exigences légales.'
                : 'Account deletion requests will be processed within 30 days. Audit logs are retained as required by law.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">8. {isFr ? 'Notification de violation' : 'Breach Notification'}</h2>
            <p>
              {isFr
                ? 'En cas de violation de données présentant un risque réel de préjudice grave, nous notifierons le Commissariat à la protection de la vie privée du Canada dans les 72 heures et les personnes concernées sans délai injustifié.'
                : 'In the event of a data breach presenting a real risk of significant harm, we will notify the Office of the Privacy Commissioner of Canada within 72 hours and affected individuals without undue delay.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-brand-navy">9. {isFr ? 'Contact' : 'Contact'}</h2>
            <p>
              {isFr ? 'Pour toute question concernant la confidentialité:' : 'For any privacy questions:'}
              <br />
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
