User        = require '../models/user'
counterCtrl = require './counter'
config      = require '../config/sys.json'
locale      = require '../config/' + config.locale + '.json'
async       = require 'async'

_           =

    outputErr: (err, methodName, cb) ->
        console.error 'controller.user #%s():', methodName
        console.error err

        cb
            success : false
            msg     : locale['error-database']

    # @method #login(username, password, cb)
    # 用户登录验证
    # @static
    # @param {String} username
    # @param {String} password
    # @param {Function} cb(data)
    #
    login: (username, password, cb) ->

        async.waterfall [
            (cbw) ->
                User.login username, password, cbw

            (user, cbw) ->
                if user?
                    if user.enable
                        cb
                            success : true
                            user    : user
                            msg     : locale['login-success']

                    else
                        cb
                            success : false
                            msg     : locale['login-fail-user-disable']
                else
                    cb
                        success : false
                        msg     : locale['login-fail-check-your-account']

        ], (err) ->
            outputErr err, 'login', cb

    # @method #addUser(obj, cb)
    # 保存当前对象
    # @static
    # @param {Object} obj
    # @param {Function} cb(data)
    #
    addUser: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                User.getUserId obj, cbw

            (_id, cbw) ->
                if _id?
                    cb
                        success : false
                        msg     : locale['add-user-fail-exists']

                else
                    counterCtrl._.getNextSequence 'userId', cbw

            (seq, cbw) ->
                obj._id     = seq
                user    = new User obj

                user.addUser cbw

            (user, cbw) ->
                cb
                    success : true
                    user    : user

        ], (err) ->
            _.outputErr err, 'addUser', cb

    # @method #updateUser(obj, cb)
    # 更新当前对象
    # @static
    # @param {Object} obj
    # @param {Function} cb(data)
    #
    updateUser: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                User.getUserUsernameById obj._id, cbw

            (userName, cbw) ->
                unless userName?
                    cb
                        success : false
                        msg     : locale['update-user-fail-not-exists']

                else if userName isnt obj.username
                    User.existsUser obj, cbw

                else
                    cbw null, false

            (bool, cbw) ->
                if bool
                    cb
                        success : false
                        msg     : locale['update-user-fail-exists']

                else
                    User.updateUser obj, cbw

            (user, cbw) ->
                cb
                    success : true
                    user    : user

        ], (err) ->
            _.outputErr err, 'updateUser', cb

    # @method #removeUser(_id, cb)
    # 删除当前user对象
    # @static
    # @param {String} _id
    # @param {Function} cb(data)
    #
    removeUser: (_id, cb) ->
        async.waterfall [
            (cbw) ->
                User.isUserDeletable _id, cbw

            (bool, cbw) ->
                unless bool
                    cb
                        success : false
                        msg     : locale['remove-user-fail-not-deletable']

                else
                    User.removeUser _id, cbw

            (user, cbw) ->
                cb
                    success : true
                    user    : user

        ], (err) ->
            _.outputErr err, 'removeUser', cb

    # @method #getUserId(obj, cb)
    # 根据userName取得userId
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, userId)
    #
    getUserId: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                User.getUserId obj, cbw

            (_id, cbw) ->
                cb
                    success : true
                    _id     : _id

        ], (err) ->
            _.outputErr err, 'getUserId', cb

    # @method #getUsers(isFullFields, cb)
    # 得到所有users数据
    # @static
    # @param {Boolean} isFullFields
    # @param {Function} cb(data)
    #
    getUsers: (isFullFields, cb) ->
        async.waterfall [
            (cbw) ->
                User.getUsers isFullFields, cbw

            (users, cbw) ->
                cb
                    success : true
                    users   : users

        ], (err) ->
            _.outputErr err, 'getUsers', cb

userCtrl    =

    _       : _

    # @method #login(req, res)
    # 用户登录验证
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    login: (req, res) ->
        _.login req.body.username, req.body.password, (data) ->
            if data.success is true
                req.session.user = data.user
                delete data.user

            res.json data

    # @method #add(req, res)
    # 新增
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    add: (req, res) ->
        _.addUser req.body, (data) ->
            if data.success
                userCtrl.getFull req, res

            else
                res.json data

    # @method #update(req, res)
    # 修改
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    update: (req, res) ->
        _.updateUser req.body, (data) ->
            if data.success
                if data.user.username is req.session.user.username
                    delete req.session.user

                userCtrl.getFull req, res

            else
                res.json data

    # @method #remove(req, res)
    # 删除
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    remove: (req, res) ->
        _.removeUser req.body._id, (data) ->
            if data.success
                if data.user.username is req.session.user.username
                    delete req.session.user

                userCtrl.getFull req, res

            else
                res.json data

    # @method #getAll(req, res)
    # 将所有数据结果集传递给http请求
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    getAll: (req, res) ->
        _.getUsers false, (data) ->
            res.json data

    # @method #getFull(req, res)
    # 将所有数据结果集传递给http请求
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    getFull: (req, res) ->
        _.getUsers true, (data) ->
            res.json data

module.exports = userCtrl
