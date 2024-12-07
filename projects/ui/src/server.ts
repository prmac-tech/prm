import express from 'express';
import path from 'path';
import nunjucks from 'nunjucks'
// import {indexController} from './controllers/indexController';
import setUpWebSession from "./session/session";
import setUpAuth from "./security/authentication";
import {Services} from "./services";
import routes from "./routes";
import config from "./config";
import setUpCurrentUser from "./authentication/setUpCurrentUser";
import InMemoryTokenStore from "./data/tokenStore/inMemoryTokenStore";


export default function createApp(services: Services): express.Application {
  //require('dotenv').config({debug: true})
  const app = express();
  const port = process.env.PORT || 3000;

  //app.get('/', indexController);

  console.log(`here with ${config.apis.auth.systemClientId}`)

  app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
  });

  app.set('views', path.join(__dirname, '/views'));

  const nunjuckLoader = new nunjucks.FileSystemLoader(app.get('views'));

  const nunjuckLoaderOptions = {
    watch: process.env.NUNJUCKS_LOADER_WATCH === 'true',
    noCache: process.env.NUNJUCKS_LOADER_NO_CACHE === 'true',
  };

  const nunjucksEnvironment = new nunjucks.Environment(
    nunjuckLoader,
    nunjuckLoaderOptions
  );

  nunjucksEnvironment.express(app);

  const Keycloak = require('keycloak-connect');
  //const keycloakConfig = require('keycloak.json');
  // const session = require('express-session');
  // const memoryStore = new session.MemoryStore();
  // const keycloak = new Keycloak({ store: memoryStore });
  //
  // app.use(session({
  //   secret: 'mymKWhjV<T=-*VW<;cC5Y6U-{F.ppK+])',
  //   resave: false,
  //   saveUninitialized: true,
  //   store: memoryStore
  // }));
  // app.use(keycloak.middleware());
  //
  // app.get('/paul', keycloak.protect(),(req, res, next) => {
  //   //const role = req.params.role;
  //   //roleCheckMiddleware(req, res, async () => {
  //     try{
  //
  //       //const username = req.kauth.grant.access_token.content.preferred_username;
  //
  //       res.send(`
  //
  //       <h1>Space </h1>
  //       <p>Welcome </p>
  //       <form action="/logout" method="post">
  //           <button type="submit">Logout</button>
  //       </form>
  //
  //   `);
  //     } catch (error) {
  //       console.error('Error:', error);
  //       res.status(500).send('Internal server error.');
  //     }
  //   });

  app.set('view engine', 'njk');
  app.set('trust proxy', 1)
  app.use(setUpWebSession())
  //app.use(setUpAuth())
  //app.use(setUpCurrentUser(services))
  app.use(routes(services))

  return app
}
