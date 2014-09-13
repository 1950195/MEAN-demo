async           = require 'async'
counterCtrl     = require '../controllers/counter'

module.exports  =
    showCounters: (cb) ->
        counterCtrl._.getCounters (err, counters) ->
            console.log 'get all counters:'
            console.log '%j', counter for counter in counters
            cb null
