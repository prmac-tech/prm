import logger from '../logger'
import config from '../config'
import RestClient from './restClient'

export interface User {
  username: string
  name?: string
  active?: boolean
  authSource?: string
  uuid?: string
  userId?: string
}

export interface UserRole {
  roleCode: string
}

export default class ManageUsersApiClient {
  constructor() {}

  private static restClient(token: string): RestClient {
    return new RestClient('User Api Client', config.apis.user, token)
  }

  getUser(token: string): Promise<User> {
    logger.info('Getting user details: calling Keycloak userinfo endpoint')
    return ManageUsersApiClient.restClient(token).get<User>({ path: '/realms/prm/protocol/openid-connect/userinfo' })
  }
}
