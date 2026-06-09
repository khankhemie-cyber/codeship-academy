import { SignJWT, jwtVerify } from 'jose'

const secret = new TextEncoder().encode(
  process.env.CRON_SECRET ?? process.env.UNSUBSCRIBE_SECRET ?? 'dev-unsubscribe-secret-change-me'
)

export const UNSUBSCRIBE_SECRET = secret

export async function createUnsubscribeToken(userId: string, consentType: string) {
  return new SignJWT({ userId, consentType })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('90d')
    .sign(secret)
}

export async function verifyUnsubscribeToken(token: string) {
  const { payload } = await jwtVerify(token, secret)
  return payload as { userId: string; consentType: string }
}
