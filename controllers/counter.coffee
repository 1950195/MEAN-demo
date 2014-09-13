Counter     = require '../models/counter'
async       = require 'async'

_           =
    getCounters: (cb) ->
        Counter.getCounters '_id, seq', cb

    # @method #getNextSequence(_id, cb)
    # 返回指定collection对应的自增序号
    # @static
    # @param {String} _id
    # @param {Function} cb(err, seq)
    #
    getNextSequence: (_id, cb) ->
        async.waterfall [
            (cbw) ->
                Counter.updateCounter _id, cbw

            (newCounter, cbw) ->
                seq = newCounter.seq if newCounter?

                if seq?
                    cb null, Counter._padId(seq)
                else
                    counter = new Counter
                        _id: _id

                    counter.addCounter cbw

            (newCounter, cbw) ->
                seq = newCounter.seq if newCounter?

                cb null, Counter._padId(seq)

        ], (err) ->
            cb err

counterCtrl =
    _: _

module.exports = counterCtrl
