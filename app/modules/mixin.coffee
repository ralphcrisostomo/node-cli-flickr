'use strict'

chalk   = require('chalk')
fs      = require('fs')
mixin   =

  write : (color = 'blue', message) ->
    return false if process.env.NODE_ENV is 'test'
    process.stdout.write chalk[color] message

  updateManifestStatus : (name, id, status = 'created') ->
    (callback) ->
      item      = null
      arr       = []
      file      = "#{process.cwd()}/#{name}/manifest.json"
      manifest  = require(file)
      manifest?.forEach (_item) ->
        if parseInt(_item?.id) is parseInt(id)
          item          = _item
          _item.status  = status
        arr.push _item
        fs.writeFile file, JSON.stringify(arr, null, 4), (err) =>
          callback null, manifest



module.exports = mixin