mongoose    = require 'mongoose'
Schema      = mongoose.Schema

# @attribute {String} username 登录用户名
# @attribute {String} password 登录密码
# @attribute {String} name 名称
# @attribute {String} userGroup UserGroup._id
# @attribute {Boolean} enable 状态是否可用 default: true
# @attribute {Boolean} deletable 状态是否可删除 default: true
#
userSchema  = new Schema
    _id                 : {type: String,    index   : true}
    username            : {type: String,    index   : true}
    password            : {type: String}
    name                : {type: String}
    userGroup           : {type: String,    ref     : 'UserGroup'}
    enable              : {type: Boolean,   default : true}
    deletable           : {type: Boolean,   default : true}

userSchema.statics =

    # @method #updateUser(obj, cb)
    # 更新数据
    # @static
    # @param {Object} obj _id以及需要更新的字段
    # @param {Function} cb(err, newUser) 回调函数
    #
    updateUser: (obj, cb) ->
        @.findByIdAndUpdate obj._id, obj, cb

    # @method #getUserById(_id, cb)
    # 获取_id对应的数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, user) 回调函数
    #
    getUserById: (_id, cb) ->
        @.findById _id, cb

    # @method #getUserUsernameById(_id, cb)
    # 获取_id对应的username
    # @static
    # @param {String} _id
    # @param {Function} cb(err, username) 回调函数
    #
    getUserUsernameById: (_id, cb) ->
        @.findById _id, 'username', (err, user) ->
            cb err, (user.username if user?)

    # @method #login(username, password, cb)
    # 登录
    # @static
    # @param {String} username
    # @param {String} password
    # @param {Function} cb(err, _id) 回调函数
    #
    login: (username, password, cb) ->
        conditions      =
            username    : username
            password    : password

        @.findOne conditions
        .populate 'userGroup', 'name, level'
        .exec cb

    # @method #getUserId(obj, cb)
    # 获取对应的数据
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, _id) 回调函数
    #
    getUserId: (obj, cb) ->
        conditions      =
            username    : obj.username
            userGroup   :
                _id     : obj.userGroup._id

        @.findOne conditions, '_id', (err, user) ->
            cb err, (user._id if user?)

    # @method #existsUser(obj, cb)
    # 判断是否存在
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, bool) 回调函数
    #
    existsUser: (obj, cb) ->
        conditions  =
            username: obj.username

        @.findOne conditions, '_id', (err, user) ->
            cb err, user? and user._id?

    # @method #isUserEnable(_id, cb)
    # 获取userId对应的数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, bool) 回调函数
    #
    isUserEnable: (_id, cb) ->
        @.findById _id, 'enable', (err, user) ->
            cb err, (user.enable if user?)

    # @method #isUserDeletable(_id, cb)
    # 获取userId对应的数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, bool) 回调函数
    #
    isUserDeletable: (_id, cb) ->
        @.findById _id, 'deletable', (err, user) ->
            cb err, (user.deletable if user?)

    # @method #getUsers(isFullFields, cb)
    # 查询所有数据
    # @static
    # @param {Boolean} isFullFields
    # @param {Function} cb(err, users) 回调函数
    #
    getUsers: (isFullFields, cb) ->
        if isFullFields
            @.find {}, 'name username password enable deletable userGroup'
            .populate 'userGroup', 'name level'
            .exec cb

        else
            @.find {}, 'name username userGroup', cb

    # @method #removeUser(_id, cb)
    # 删除此条数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, oldUser) 回调函数
    #
    removeUser: (_id, cb) ->
        @.findByIdAndRemove _id, cb

    # @method #removeUsers(cb)
    # 删除所有数据
    # @static
    # @param {Function} cb(err) 回调函数
    #
    removeUsers: (cb) ->
        @.remove {}, cb

userSchema.methods =

    # @method #addUser(cb)
    # 存储当前对象
    # @param {Function} cb(err, newUser, numberAffected) 回调函数
    #
    addUser: (cb) ->
        @.save cb

module.exports = mongoose.model 'User', userSchema
