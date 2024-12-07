
import { dataAccess } from '../data'
import UserService from './userService'

export const services = () => {
  const { authClient, manageUsersApiClient } = dataAccess()

  const userService = new UserService(manageUsersApiClient)

  return {
    authClient: authClient,
    userService,
  }
}

export type Services = ReturnType<typeof services>

export { UserService }
