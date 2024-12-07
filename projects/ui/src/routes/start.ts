import { type RequestHandler, Router } from 'express'

import asyncMiddleware from './asyncMiddleware'
import type { Services } from '../services'
import config from "../config";


export default function startRoutes(router: Router, { authClient }: Services) {
  const get = (path: string | string[], handler: RequestHandler) => router.get(path, asyncMiddleware(handler))

  get('/', async (req, res, _next) => {
    //const token = await authClient.getSystemClientToken(res?.locals?.user?.username)
    res.render('index', {
      headerText: `PRM UI is running and logged in as ${process.env.PRM_TEST} with ${process.env.API_CLIENT_SECRET}`,
      titleText: 'Home page',
    });
  })
}
