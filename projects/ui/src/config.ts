const production = process.env.NODE_ENV === 'production'
require('dotenv').config({debug: true})
function get<T>(name: string, fallback: T, options = { requireInProduction: false }): T | string {
  if (process.env[name]) {
    return process.env[name]
  }
  if (fallback !== undefined && (!production || !options.requireInProduction)) {
    return fallback
  }
  throw new Error(`Missing env var ${name}`)
}

const requiredInProduction = { requireInProduction: true }

export class AgentConfig {
  // Sets the working socket to timeout after timeout milliseconds of inactivity on the working socket.
  timeout: number

  constructor(timeout = 8000) {
    this.timeout = timeout
  }
}

export interface ApiConfig {
  url: string
  timeout: {
    response: number
    deadline: number
  }
  agent: AgentConfig
}

export default {
  env: get('ENVIRONMENT', 'local', requiredInProduction) as 'local' | 'dev' | 'preprod' | 'prod',
  https: true,
  session: {
    secret: get('SESSION_SECRET', 'app-insecure-default-session', requiredInProduction),
    expiryMinutes: Number(get('WEB_SESSION_TIMEOUT_IN_MINUTES', 120)),
  },
  apis: {
    user: {
      url: get('USER_API_URL', 'https://auth.pr-mac.com', requiredInProduction),
      timeout: {
        response: Number(get('USER_API_TIMEOUT_RESPONSE', 10000)),
        deadline: Number(get('USER_API_TIMEOUT_DEADLINE', 10000)),
      },
      agent: new AgentConfig(Number(get('USER_API_TIMEOUT_RESPONSE', 10000))),
    },
    auth: {
      url: get('AUTH_URL', 'https://auth.pr-mac.com', requiredInProduction),
      externalUrl: get('AUTH_EXTERNAL_URL', get('AUTH_URL', 'https://auth.pr-mac.com')),
      timeout: {
        response: Number(get('AUTH_TIMEOUT_RESPONSE', 10000)),
        deadline: Number(get('AUTH_TIMEOUT_DEADLINE', 10000)),
      },
      agent: new AgentConfig(Number(get('AUTH_TIMEOUT_RESPONSE', 10000))),
      apiClientId: get('API_CLIENT_ID', 'api_client', requiredInProduction),
      apiClientSecret: get('API_CLIENT_SECRET', 'api_secret', requiredInProduction),
      systemClientId: get('SYSTEM_CLIENT_ID', 'prm-client', requiredInProduction),
      systemClientSecret: get('SYSTEM_CLIENT_SECRET', 'prm-secret', requiredInProduction),
    },
    tokenVerification: {
      url: get('TOKEN_VERIFICATION_API_URL', 'http://localhost:8100', requiredInProduction),
      timeout: {
        response: Number(get('TOKEN_VERIFICATION_API_TIMEOUT_RESPONSE', 5000)),
        deadline: Number(get('TOKEN_VERIFICATION_API_TIMEOUT_DEADLINE', 5000)),
      },
      agent: new AgentConfig(Number(get('TOKEN_VERIFICATION_API_TIMEOUT_RESPONSE', 5000))),
      enabled: get('TOKEN_VERIFICATION_ENABLED', 'false') === 'true',
    },
  },
  domain: get('INGRESS_URL', 'http://localhost:3000', requiredInProduction),
  environmentName: get('ENVIRONMENT_NAME', ''),
}
