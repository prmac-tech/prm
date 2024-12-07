import { Router } from 'express'

import type { Services } from '../services'

import startRoutes from "./start";

export default function routes(services: Services): Router {
  const router = Router()
  startRoutes(router, services)
  return router
}
