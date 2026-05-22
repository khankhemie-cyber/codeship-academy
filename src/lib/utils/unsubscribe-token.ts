import { SignJWT } from 'jose'

const SECRET = new TextEncoder().encode(process.env.CRON_SECRET ?? 'fallback-secret-change-in-prod')

export async function signUnsubscribeToken(userId: string, consentType: string): Promise<string> {
  return new SignJWT({ userId, consentType })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('60d')
    .sign(SECRET)
}

export { SECRET as UNSUBSCRIBE_SECRET }
