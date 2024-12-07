import passport from 'passport'
import { Strategy as OAuth2Strategy } from 'passport-oauth2'
import type { RequestHandler } from 'express'
import config from '../config'
import generateOauthClientToken from './clientCredentials'
import type { TokenVerifier } from '../data/tokenVerification'
import KeycloakStrategy from "@exlinc/keycloak-passport";

passport.serializeUser((user, done) => {
  // Not used but required for Passport
  done(null, user)
})

passport.deserializeUser((user, done) => {
  // Not used but required for Passport
  done(null, user as Express.User)
})

export type AuthenticationMiddleware = (tokenVerifier: TokenVerifier) => RequestHandler

const authenticationMiddleware: AuthenticationMiddleware = verifyToken => {
  return async (req, res, next) => {
    if (req.isAuthenticated() && (await verifyToken(req))) {
      return next()
    }
    req.session.returnTo = req.originalUrl
    return res.redirect('/sign-in')
  }
}

function init(): void {

  const keycloakStrategy =   new OAuth2Strategy(
    {
      //issuer: `${config.apis.auth.externalUrl}/realms/prm/protocol/openid-connect/auth`,
      //host: config.apis.auth.externalUrl,
      //realm: "prm",
      clientID: config.apis.auth.apiClientId,
      clientSecret: config.apis.auth.apiClientSecret,
      callbackURL: `${config.domain}/sign-in/callback`,
      authorizationURL: `${config.apis.auth.externalUrl}/realms/prm/protocol/openid-connect/auth`,
      tokenURL:`${config.apis.auth.externalUrl}/realms/prm/protocol/openid-connect/token`,
      //userInfoURL: `${config.apis.auth.externalUrl}/realms/prm/protocol/openid-connect/userinfo`,
      state: true,
      //customHeaders: { Authorization: generateOauthClientToken() },
    },
    (token, refreshToken, params, profile, verified) => {

      console.log("Here with " + token)
      console.log("Here with " + JSON.stringify(params))
      console.log("Here with profile " + JSON.stringify(profile))

      return verified(null, { token, username: params.user_name, authSource: params.auth_source })
      // This is called after a successful authentication has been completed
      // Here's a sample of what you can then do, i.e., write the user to your DB
      // User.findOrCreate({ email: profile.email }, (err, user) => {
      //   assert.ifError(err);
      //   user.keycloakId = profile.keycloakId;
      //   user.imageUrl = profile.avatar;
      //   user.name = profile.name;
      //   user.save((err, savedUser) => done(err, savedUser));
      // });
    }
  )

  const oauth2Strategy = new OAuth2Strategy(
    {
      authorizationURL: `${config.apis.auth.externalUrl}/realms/prm/protocol/openid-connect/auth`,
      tokenURL: `${config.apis.auth.url}/oauth/token`,
      clientID: config.apis.auth.apiClientId,
      clientSecret: config.apis.auth.apiClientSecret,
      callbackURL: `${config.domain}/sign-in/callback`,
      state: true,
      customHeaders: { Authorization: generateOauthClientToken() },
    },
    (token, refreshToken, params, profile, done) => {
      return done(null, { token, username: params.user_name, authSource: params.auth_source })
    },
  )

  passport.use('keycloak', keycloakStrategy)
  passport.use('oauth2', oauth2Strategy)
}

export default {
  authenticationMiddleware,
  init,
}
