http          = require 'http'
path          = require 'path'
express       = require 'express'
passport      = require 'passport'
LocalStrategy = require('passport-local').Strategy

USER =
  username: 'test'
  password: 'pass'

passport.serializeUser   (user, cb)     -> cb null, user.username
passport.deserializeUser (username, cb) -> cb null, USER
passport.use new LocalStrategy (username, password, cb) ->
  return cb null, USER if username == USER.username && password == USER.password
  return cb null, false

app = express()
app.configure ->
  app.use express.logger()
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session
    secret: '+D=FPE*Ek#p@wlX`5oI293o/dsZ$6/cmt}+y|A2`(!S=UE-ha_zh!R@}mN+&etGG'
    store:  express.session.MemoryStore()
    cookie:
      httpOnly: true
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static 'public'

# Post to /login/login because static file (i.e. /login) cannot handle POST
# and nginx would return HTTP 405
app.post '/login/login', passport.authenticate('local'), (req, res) ->
  res.redirect '/'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/login'

app.all '*', (req, res, next) ->
  return next() if req.user?
  return res.redirect '/login'

app.all '*', (req, res) ->
  if /^(\/css\/|\/js\/)/.test req.path
  then res.set 'X-Accel-Redirect', "/assets/#{req.path}"
  else res.set 'X-Accel-Redirect', '/assets/index.html'
  res.send()

server = http.createServer app
server.listen process.env.npm_package_config_port
console.log "Server listening on port #{process.env.npm_package_config_port}"
