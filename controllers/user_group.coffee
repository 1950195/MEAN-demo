UserGroup   = require '../models/user_group'
counterCtrl = require './counter'
config      = require '../config/sys.json'
locale      = require '../config/' + config.locale + '.json'
async       = require 'async'

_           =

    outputErr: (err, methodName, cb) ->
        console.error 'controller.userGroup #%s():', methodName
        console.error err

        cb
            success : false
            msg     : locale['error-database']

    # @method #addUserGroup(obj, cb)
    # 保存当前对象
    # @static
    # @param {Object} obj
    # @param {Function} cb(data)
    #
    addUserGroup: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                UserGroup.getUserGroupId obj, cbw

            (_id, cbw) ->
                if _id?
                    cb
                        success : false
                        msg     : locale['add-user-group-fail-exists']
                else
                    counterCtrl._.getNextSequence 'userGroupId', cbw

            (seq, cbw) ->
                obj._id         = seq
                userGroup       = new UserGroup obj

                userGroup.addUserGroup cbw

            (userGroup, cbw) ->
                cb
                    success     : true
                    userGroup   : userGroup

        ], (err) ->
            _.outputErr err, 'addUserGroup', cb

    # @method #updateUserGroup(obj, cb)
    # 更新当前对象
    # @static
    # @param {Object} obj
    # @param {Function} cb(data)
    #
    updateUserGroup: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                UserGroup.getUserGroupNameById obj._id, cbw

            (userGroupName, cbw) ->
                unless userGroupName?
                    cb
                        success : false
                        msg     : locale['update-user-group-fail-not-exists']

                else if userGroupName isnt obj.name
                    UserGroup.existsUserGroup obj, cbw

                else
                    cbw null, false

            (bool, cbw) ->
                if bool
                    cb
                        success : false
                        msg     : locale['update-user-group-fail-exists']

                else
                    UserGroup.updateUserGroup obj, cbw

            (userGroup, cbw) ->
                cb
                    success     : true
                    userGroup   : userGroup

        ], (err) ->
            _.outputErr err, 'updateUserGroup', cb

    # @method #removeUserGroup(_id, cb)
    # 删除当前userGroup对象
    # @static
    # @param {String} _id
    # @param {Function} cb(data)
    #
    removeUserGroup: (_id, cb) ->
        async.waterfall [
            (cbw) ->
                UserGroup.isUserGroupDeletable _id, cbw

            (bool, cbw) ->
                unless bool
                    cb
                        success : false
                        msg     : locale['remove-user-group-fail-not-deletable']

                else
                    UserGroup.removeUserGroup _id, cbw

            (userGroup, cbw) ->
                cb
                    success     : true
                    userGroup    : userGroup

        ], (err) ->
            _.outputErr err, 'removeUserGroup', cb

    # @method #getUserGroupId(obj, cb)
    # 根据userGroupName取得userGroupId
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, userGroupId)
    #
    getUserGroupId: (obj, cb) ->
        async.waterfall [
            (cbw) ->
                UserGroup.getUserGroupId obj, cbw

            (_id, cbw) ->
                cb
                    success : true
                    _id     : _id

        ], (err) ->
            _.outputErr err, 'getUserGroupId', cb

    # @method #getUserGroups(isFullFields, cb)
    # 返回所有userGroup
    # @static
    # @param {Boolean} isFullFields
    # @param {Function} cb(data)
    #
    getUserGroups: (isFullFields, cb) ->
        async.waterfall [
            (cbw) ->
                UserGroup.getUserGroups isFullFields, cbw

            (userGroups, cbw) ->
                cb
                    success     : true
                    userGroups  : userGroups

        ], (err) ->
            _.outputErr err, 'getAll', cb

userGroupCtrl   =
    _           : _

    # @method #add(req, res)
    # 新增
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    add: (req, res) ->
        _.addUserGroup req.body, (data) ->
            if data.success
                userGroupCtrl.getFull req, res

            else
                res.json data

    # @method #update(req, res)
    # 修改
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    update: (req, res) ->
        _.updateUserGroup req.body, (data) ->
            if data.success
                userGroupCtrl.getFull req, res

            else
                res.json data

    # @method #remove(req, res)
    # 删除
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    remove: (req, res) ->
        _.removeUserGroup req.body._id, (data) ->
            if data.success
                userGroupCtrl.getFull req, res

            else
                res.json data

    # @method #getAll(req, res)
    # 将所有数据结果集传递给http请求
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    getAll: (req, res) ->
        _.getUserGroups false, (data) ->
            res.json data

    # @method #getFull(req, res)
    # 将所有数据结果集传递给http请求
    # @static
    # @param {Object} req http.Request
    # @param {Object} res http.Response
    #
    getFull: (req, res) ->
        _.getUserGroups true, (data) ->
            res.json data

module.exports  = userGroupCtrl
