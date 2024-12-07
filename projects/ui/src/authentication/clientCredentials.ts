import config from '../config'

export default function generateOauthClientToken(
  clientId: string = config.apis.auth.apiClientId,
  clientSecret: string = config.apis.auth.apiClientSecret,
): string {
  const token = Buffer.from(`${clientId}:${clientSecret}`).toString('base64')
  return `Basic ${token}`
}
