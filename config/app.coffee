###
# Module dependencies.
###
express         = require 'express'
path            = require 'path'
hbs             = require 'hbs'
favicon         = require 'serve-favicon'
logger          = require 'morgan'
session         = require 'express-session'
bodyParser      = require 'body-parser'
pkg             = require '../package.json'
router          = require './router'
app             = express()
faviconPath     = path.join __dirname, '../assets/favicon.ico'
assetsPath      = path.join __dirname, '../assets'
viewsPath       = path.join __dirname, '../views'
hbsPartialsPath = path.join __dirname, '../views/partials'

app.set 'view engine', 'hbs'
app.set 'views', viewsPath
hbs.registerPartials hbsPartialsPath
app.use express.static assetsPath
app.use favicon faviconPath
app.use logger 'dev'
app.use session
    name        : 'sid'
    secret      : pkg.name
    cookie      :
        maxAge  : 20 * 60 * 1000
    resave      : true
    saveUninitialized   : true
app.use bodyParser.json()
app.use bodyParser.urlencoded
    extended    : true

# routes
app.use router

module.exports = app
