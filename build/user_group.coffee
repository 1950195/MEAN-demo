userGroupCtrl   = require '../controllers/user_group'
async           = require 'async'

module.exports  =
    addUserGroup: (objs, cb) ->
        fn = arguments.callee

        async.waterfall [
            (cbw) ->
                if objs.length > 0
                    cbw null, objs.shift()

                else
                    cb null

            (obj, cbw) ->
                obj.deletable = false

                userGroupCtrl._.addUserGroup obj, (data) ->
                    fn objs, cb

        ], (err) ->
            cb err

    showUserGroups: (cb) ->
        userGroupCtrl._.getUserGroups true, (data) ->
            console.log 'get all userGroups:'
            console.log '%j', userGroup for userGroup in data.userGroups
            cb null
