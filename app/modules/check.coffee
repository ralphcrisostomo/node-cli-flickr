'use strict'

_         = require('lodash')
async     = require('async')
fs        = require('fs')
path      = require('path')
Manifest  = require('./manifest')
mixin     = require('./mixin')


# Psuedocode
# ------------------------------
# - Check directory
# - Check manifest
# - Check videos

class Check

  constructor : ->

  run  : (flickr, name) ->
    (callback) =>
      async.series [
        @_checkDirectory(name)
        @_checkManifest(flickr,name)
        @_checkVideos(name)
      ], callback


  _checkDirectory : (name) ->
    (callback) ->
      mixin.write 'blue', '\nChecking directory...'
      directory = "#{process.cwd()}/#{name}"
      #
      # Create directory
      #
      if not fs.existsSync(directory)
        mixin.write 'red', '\nDirectory do not exist.'
        mixin.write 'blue', '\nCreating directory....'
        fs.mkdir "#{directory}", '0777', (err) ->
          mixin.write 'green', '\nError while creating directory!' if err
          mixin.write 'green', '\nCreating directory : done'
          callback null, {}
      else
        mixin.write 'green', "\nChecking directory : done"
        callback null, {}


  _checkManifest : (flickr,name) ->
    (callback) ->
      mixin.write 'blue', '\nChecking `.manifest.json`...'
      directory = "#{process.cwd()}/#{name}"
      #
      # Create manifest
      #
      if not fs.existsSync("#{directory}/.manifest.json")
        mixin.write 'red', '\n`.manifest.json` do not exist.'
        manifest = new Manifest()
        manifest.create(flickr, name, 1) callback

      else
        mixin.write 'green', '\nChecking `.manifest.json` : done'
        callback null, {}


  _checkVideos : (name) ->
    (callback) ->
      mixin.write 'blue', '\nChecking videos...'
      async.waterfall [
        #
        # Get video ids
        #
        (callback) ->
          mixin.write 'blue', "\nGetting video ids..."
          ids         = []
          directory   = "#{process.cwd()}/#{name}"
          fs.readdir directory, (err, files) ->
            mixin.write 'green', "\nGetting video ids : done"
            files.forEach (item) ->
              matched = item?.match(/(\d+)/g)
              ids     = _.union ids, matched
            callback err, ids
      ,
        #
        # Update status
        #
        (input, callback) ->
          mixin.write 'blue', "\nUpdating status..."
          arr       = []
          ids       = input

          manifest  = "#{process.cwd()}/#{name}/.manifest.json"
          manifest  = require(manifest)
          manifest?.forEach (item) ->
            item.status = 'created'
            ids?.forEach (id) ->
              item.status = 'completed' if item.id is parseInt(id)
            arr.push item
          mixin.write 'green', "\nUpdating status : done"
          callback null, arr
      ,
        #
        # Update `.manifest.json`
        #
        (input, callback) ->
          mixin.write 'blue', "\nUpdating `.manifest.json`..."
          manifest  = input
          file      = "#{process.cwd()}/#{name}/.manifest.json"
          fs.writeFile file, JSON.stringify(manifest, null, 4), (err) ->
            mixin.write 'green', "\nUpdating `.manifest.json` : done"
            callback err, manifest

      ], (err, result) ->
        manifest  = result
        completed = _.filter(manifest, { 'status': 'completed'})
        mixin.write 'green', '\nChecking videos : done'
        mixin.write 'magenta', "\n\nDownloaded Videos : #{completed?.length} of #{manifest?.length}\n"
        callback err, result



module.exports = Check