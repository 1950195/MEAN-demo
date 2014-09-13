mongoose        = require 'mongoose'
Schema          = mongoose.Schema

# @attribute {String} name 用户身份名称
# @attribute {Number} level 权限级别0最高
# @attribute {Boolean} deletable 状态是否可删除 default: true
#
userGroupSchema = new Schema
    _id         : {type: String,    index   : true}
    name        : {type: String,    index   : true}
    level       : {type: Number,    index   : true}
    deletable   : {type: Boolean,   default : true}

userGroupSchema.statics =

    # @method #updateUserGroup(obj, cb)
    # 更新数据
    # @static
    # @param {Object} obj _id以及需要更新的字段
    # @param {Function} cb(err, newUserGroup) 回调函数
    #
    updateUserGroup: (obj, cb) ->
        @.findByIdAndUpdate obj._id, obj, cb

    # @method #getUserGroupById(_id, cb)
    # 获取_id对应的数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, userGroup) 回调函数
    #
    getUserGroupById: (_id, cb) ->
        @.findById _id, cb

    # @method #getUserGroupNameById(_id, cb)
    # 获取_id对应的name
    # @static
    # @param {String} _id
    # @param {Function} cb(err, name) 回调函数
    #
    getUserGroupNameById: (_id, cb) ->
        @.findById _id, 'name', (err, userGroup) ->
            cb err, (userGroup.name if userGroup?)

    # @method #getUserGroupId(obj, cb)
    # 获取对应的数据
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, _id) 回调函数
    #
    getUserGroupId: (obj, cb) ->
        conditions  =
            name    : obj.name

        @.findOne conditions, '_id', (err, userGroup) ->
            cb err, (userGroup._id if userGroup?)

    # @method #existsUserGroup(obj, cb)
    # 判断是否存在
    # @static
    # @param {Object} obj
    # @param {Function} cb(err, bool) 回调函数
    #
    existsUserGroup: (obj, cb) ->
        conditions  =
            name    : obj.name

        @.findOne conditions, '_id', (err, userGroup) ->
            cb err, userGroup? and userGroup._id?

    # @method #isUserGroupDeletable(_id, cb)
    # 获取userId对应的数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, bool) 回调函数
    #
    isUserGroupDeletable: (_id, cb) ->
        @.findById _id, 'deletable', (err, userGroup) ->
            cb err, (userGroup.deletable if userGroup?)

    # @method #getUserGroups(isFullFields, cb)
    # 查询所有数据
    # @static
    # @param {String} isFullFields
    # @param {Function} cb(err, userGroups) 回调函数
    #
    getUserGroups: (isFullFields, cb) ->
        if isFullFields
            @.find {}, 'name level deletable', cb

        else
            @.find {}, 'name level', cb

    # @method #removeUserGroup(_id, cb)
    # 删除此条数据
    # @static
    # @param {String} _id
    # @param {Function} cb(err, oldUserGroup) 回调函数
    #
    removeUserGroup: (_id, cb) ->
        @.findByIdAndRemove _id, cb

    # @method #removeUserGroups(cb)
    # 删除所有数据
    # @static
    # @param {Function} cb(err) 回调函数
    #
    removeUserGroups: (cb) ->
        @.remove {}, cb

userGroupSchema.methods =

    # @method #addUserGroup(cb)
    # 存储当前对象
    # @param {Function} cb(err, newUserGroup, numberAffected) 回调函数
    #
    addUserGroup: (cb) ->
        @.save cb

module.exports = mongoose.model 'UserGroup', userGroupSchema
