mongoose    = require 'mongoose'

uri         = 'mongodb://localhost/bmw'

db          =
    connect: (cb) ->
        if mongoose.connection.readyState is 0

            mongoose.connect uri, cb

        else
            console.error '请先停止app！'
            db.disconnect()

    dropDBs: (cb) ->
        mongoose.connection.db.dropDatabase cb

    disconnect: ->
        mongoose.disconnect()
        process.exit 0

module.exports = db
