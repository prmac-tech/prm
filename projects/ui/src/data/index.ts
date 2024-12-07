
import AuthClient from './authClient'
import ManageUsersApiClient from './userApiClient'
import InMemoryTokenStore from './tokenStore/inMemoryTokenStore'

type RestClientBuilder<T> = (token: string) => T

export const dataAccess = () => ({
  authClient: new AuthClient(new InMemoryTokenStore(),),
  manageUsersApiClient: new ManageUsersApiClient(),
})

export type DataAccess = ReturnType<typeof dataAccess>

export { AuthClient, RestClientBuilder, ManageUsersApiClient }
