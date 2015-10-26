'use strict'

request   = require('superagent')
fs        = require('fs')
mixin     = require('./mixin')
async     = require('async')

# Psuedocode
# ------------------------------
# - _getUserId
# - _getPhotos


class Manifest

  _getUserId : (flickr, name) ->
    (callback) =>
      flickr.people.findByUsername
        api_key   : process.env.FLICKR_API_KEY
        username  : name
      , (err, result) ->
        callback err, result


  _downloadManifest : (flickr, user, page, callback) ->

    per_page  = 500
    name      = ''
    flickr.people.getPhotos
      api_key   : process.env.FLICKR_API_KEY
      user_id   : user.id
      per_page  : per_page
      page      : page
    , (err, result) =>

      return err if err
      data      = result.photos?.photo
      data?.forEach (item) =>
        @manifest.push
          id      : parseInt(item?.id)
          name    : item?.title
          status  : 'created'

      mixin.write 'cyan', "\nDownloading manifest... #{@manifest.length} of #{result?.photos.total}\r"
      return @_downloadManifest(flickr, user, page + 1, callback) if @manifest.length isnt result.photos.total
      mixin.write 'cyan', "\n------------------\n"
      mixin.write 'green', "\nDownloading manifest : done"
      mixin.write 'blue', "\nWriting `manifest.json`..."
      file = "#{process.cwd()}/#{name}/manifest.json"
      fs.writeFile file, JSON.stringify(@manifest, null, 4), (err) =>
        mixin.write 'green', "\nWriting `manifest.json` : done"
        callback err, @manifest


  constructor : ->
    @manifest = []

  create : (flickr, name) ->
    (callback) =>
      async.waterfall [
        @_getUserId(flickr, name)
      ], (err, result) =>
        user = result?.user
        mixin.write 'blue', "\nCreating `manifest.json`..."
        mixin.write 'cyan', "\n\n------------------"
        @_downloadManifest(flickr, user, 1, callback)








module.exports = Manifest