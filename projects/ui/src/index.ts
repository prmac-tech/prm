import promClient from 'prom-client'
import createApp from './server'
import { services } from './services'
require('dotenv').config({debug: true})
const app = createApp(services())

export { app }
