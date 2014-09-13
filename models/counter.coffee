mongoose        = require 'mongoose'
config          = require '../config/sys.json'
defaultId       = config['default-id']

# @attribute {String} _id collection自增列名称
# @attribute {Number} seq 自增数值 default: 1
counterSchema = new mongoose.Schema
    _id: {type: String}
    seq: {type: Number, default: 1}

counterSchema.statics =

    # @method #_padId(id)
    # 将整数补零变成一个19位的字符串返回
    # @static
    # @private
    # @param {Number} id 通过自增得到的整数
    # @return String 通过补零得到19位字符串
    #
    _padId: (id) ->
        if typeof id is 'number' and id > 0
            defaultId.concat id
            .slice -1 * defaultId.length

    # @method #updateCounter(id, cb)
    # 自增指定collection对应的id
    # @static
    # @param {String} _id collection对应的id名称
    # @param {Function} cb(err, newCounter) 回调函数
    #
    updateCounter: (_id, cb) ->
        update =
            $inc:
                seq: 1
        options =
            new: true

        @.findByIdAndUpdate _id, update, options, cb

    # @method #getCounters(cb)
    # 查询所有数据
    # @static
    # @param {Function} cb(err, counters) 回调函数
    #
    getCounters: (fields, cb) ->
        @.find {}, fields, cb

    # @method #removeCounters(cb)
    # 删除所有数据
    # @static
    # @param {Function} cb(err) 回调函数
    #
    removeCounters: (cb) ->
        @.remove {}, cb

counterSchema.methods =

    # @method #addCounter(cb)
    # 存储当前对象
    # @param {Function} cb(err, newCounter, numberAffected) 回调函数
    #
    addCounter: (cb) ->
        @.save cb

module.exports = mongoose.model 'Counter', counterSchema
