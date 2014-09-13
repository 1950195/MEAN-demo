{userList, userGroupList} = require './data'
{addUserGroup, showUserGroups} = require './user_group'
{addUser, showUsers} = require './user'
{showCounters} = require './counter'
{connect, dropDBs, disconnect} = require './db'
async = require 'async'

init = ->
    async.series [
        (cb) ->
            connect cb
        (cb) ->
            dropDBs cb
        (cb) ->
            addUserGroup userGroupList, cb
        (cb) ->
            showUserGroups cb
        (cb) ->
            addUser userList, cb
        (cb) ->
            showUsers cb
        (cb) ->
            showCounters cb
        (cb) ->
            disconnect()
    ], (err) ->
        console.error err
        disconnect()

init()
