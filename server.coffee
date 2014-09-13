###
# BMW Mystery Shopper Research
# Copyright(c) 2014 Lionel Dong <dxn1950195@gmail.com>
###

###
# Module dependencies.
###

path    = require 'path'
fs      = require 'fs'

# Bootstrap db connection
db = require './config/db'

# Bootstrap models
models_path = path.join __dirname, 'models'
fs.readdirSync models_path
.forEach (file) ->
    if file.slice(-7) is '.coffee'
        require path.join models_path, file

# express setting
app     = require './config/app'

app.set 'port', 80
port    = app.get 'port'

server = app.listen port, ->
    console.info '''
        Express server listening on port %d
        ''', server.address().port
