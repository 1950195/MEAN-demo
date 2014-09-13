express     = require 'express'
router      = express.Router()

parseCtrl   = (ctrlName) ->
    ctrlName.replace /-/g, '_'

parseMethod = (methodName) ->
    methodName.replace /-\w/g, (txt) ->
        txt.charAt 1
        .toUpperCase()

# render the page based on controller name, method and id
routeMvc = (ctrlName, methodName, req, res, next) ->
    ctrlName    = parseCtrl ctrlName
    methodName  = parseMethod methodName
    controller  = null

    try
        controller  = require '../controllers/' + ctrlName
    catch err
        console.warn 'controller not found: ' + ctrlName, err
        next()

    if typeof controller[methodName] is 'function'
        actionMethod = controller[methodName].bind controller
        actionMethod req, res
    else
        console.warn 'method not found: ' + methodName
        next()

  #   - _/_ -> controllers/index/index method
router.get '/', (req, res, next) ->
    routeMvc 'index', 'index', req, res, next

  #   - _/_ -> controllers/index/login method
router.post '/login', (req, res, next) ->
    routeMvc 'user', 'login', req, res, next

  #   - _/_ -> controllers/index/login method
router.post '/logout', (req, res, next) ->
    routeMvc 'index', 'logout', req, res, next

if process.env.NODE_ENV isnt 'test'
    router.get '*', (req, res, next) ->
        user = req.session.user
        if user?
            req.session.cookie.maxAge = 20 * 60 * 1000
            next()
        else
            res.redirect '/'

    router.post '*', (req, res, next) ->
        user = req.session.user
        if user?
            req.session.cookie.maxAge = 20 * 60 * 1000
            next()
        else
            res.json
                success: false
                timeout: true

  #   - _/**:controller**_  -> controllers/***:controller***/index method
router.get '/tpl/:tpl', (req, res, next) ->
    routeMvc 'tpl', req.params.tpl, req, res, next

  #   - _/**:controller**/**:method**_ -> controllers/***:controller***/***:method*** method
router.post '/:controller/:method', (req, res, next) ->
    if '_' is req.params.method.charAt 0
        next()
    else
        routeMvc req.params.controller, req.params.method, req, res, next

router.get '*', (req, res) ->
    res.redirect '/'

router.all '*', (req, res) ->
    res.json
        success : false
        msg     : 'Request invalid!'

module.exports = router
