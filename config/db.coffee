mongoose    = require 'mongoose'

uri         = 'mongodb://localhost/bmw'

connect = ->
    if mongoose.connection.readyState is 0
        mongoose.connect uri

connect()

CONN_ERROR = null

mongoose.connection.on 'error', (err) ->
    console.log ' mongoose connection error'
    console.log err
    CONN_ERROR = err

mongoose.connection.on 'disconnected', ->
    unless CONN_ERROR?
        connect()

module.exports = mongoose
