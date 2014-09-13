config      = require '../config/sys.json'
locale      = require '../config/' + config.locale + '.json'

hbs =
    login               :
        title           : locale['login-title']
        username        : locale['username']
        password        : locale['password']
        signIn          : locale['sign-in']
        placeholder     :
            username    : locale['placeholder-username']
            password    : locale['placeholder-password']
        tpl             :
            errorMsg    : '{{errorMsg}}'
    index               :
        title           : locale['index-title']
        welcome         : locale['welcome']
        signOut         : locale['sign-out']
        tpl             :
            navName     : '{{nav.name}}'
    navs                : [
            index       : 1
            level       : 100
            path        : '/'
            icon        : 'home'
            name        : locale['nav-home']
        ,
            index       : 2
            level       : 1
            path        : '/user'
            icon        : 'user'
            name        : locale['nav-user']
        ,
            index       : 3
            level       : 0
            path        : '/user-group'
            icon        : 'cog'
            name        : locale['nav-user-group']
    ]

module.exports =
    index: (req, res) ->
        user = req.session.user

        unless user?
            res.render 'login', hbs.login

        else
            hbs.index.user  =
                name        : user.name

            res.render 'index', hbs.index

    logout: (req, res) ->
        delete req.session.user

        res.json
            success : true

    nav: (req, res) ->
        level = req.session.user.userGroup.level

        res.json hbs.navs.filter (obj) ->
            obj.level >= level
