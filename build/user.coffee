userGroupCtrl    = require '../controllers/user_group'
userCtrl        = require '../controllers/user'
async           = require 'async'

module.exports  =
    addUser: (objs, cb) ->
        fn = arguments.callee

        async.waterfall [
            (cbw) ->
                if objs.length > 0
                    cbw null, objs.shift()

                else
                    cb null

            (obj, cbw) ->
                userGroupCtrl._.getUserGroupId {name: obj.userGroupName}, (_id) ->
                    obj.userGroup = _id if _id?
                    cbw null, obj

            (obj, cbw) ->
                obj.deletable = false

                userCtrl._.addUser obj, (data) ->
                    fn objs, cb

        ], (err) ->
            cb err

    showUsers: (cb) ->
        userCtrl._.getUsers true, (data) ->
            console.log 'get all users:'
            console.log '%j', user for user in data.users
            cb null
