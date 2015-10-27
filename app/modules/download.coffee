'use strict'

_           = require('lodash')
async       = require('async')
request     = require('superagent')
ProgressBar = require('progress')
chalk       = require('chalk')
fs          = require('fs')
mixin       = require('./mixin')

#flickr.photos.getSizes

class Download

  constructor : ->
    @retry = 0

  run : (flickr, name) ->
    (callback) =>
      async.waterfall [
        @_getId(name)
        @_getPhoto(flickr)
        @_downloadVideo(name)
        @_updateManifest(name)
      ], (err, result) =>
        if err is 'retry'
          mixin.write 'red', "\n------------------"
          mixin.write 'red', "\nRetrying... (#{@retry})"
          @run(flickr,name) callback
        else if err is 'continue'
          @run(flickr,name) callback
        else
          @retry = 0
          callback err, result

  _getPhoto : (flickr) ->
    (input, callback) =>
      photo = input
      flickr.photos.getSizes
        api_key   : process.env.FLICKR_API_KEY
        photo_id  : photo.id
      , (err, result) =>
        if err
          @retry++
          mixin.write 'cyan', '\nStatus \t\t: Failed'
          callback 'retry', null
        else
          console.log result.sizes.size
          size = _.findWhere result.sizes.size, { label : 'Large 2048' }
          size = _.findWhere result.sizes.size, { label : 'Large 1600' } if not size
          size = _.findWhere result.sizes.size, { label : 'Large' }      if not size
          size = _.findWhere result.sizes.size, { label : 'Medium 640' } if not size
          size = _.findWhere result.sizes.size, { label : 'Medium' }     if not size
          _.assign photo, size
          callback err, photo


  _getId : (name) ->
    (callback) ->
      file      = "#{process.cwd()}/#{name}/.manifest.json"
      manifest  = require(file)
      completed = _.filter(manifest, { 'status': 'completed'})
      created   = _.find(manifest, { 'status': 'created'})

      if not _.isEmpty(created)
        mixin.write 'cyan', "\n------------------"
        mixin.write 'cyan', "\nIndex \t\t: #{completed?.length + 1} of #{manifest?.length}"
        mixin.write 'cyan', "\nId \t\t: #{created?.id}"
        mixin.write 'cyan', "\nName \t\t: #{created?.name}"
        callback null, created
      else
        mixin.write 'green', "\nDownload Complete"
        callback 'completed', null


  _downloadVideo : (name) ->
    (input, callback) =>
      photo   = input
      url     = photo.source
      mixin.write 'cyan', "\nUrl \t\t: #{url}"
      request
        .get(url)
        .parse (res) =>
          file_name     = "#{photo.name} [#{photo.id}].jpg"?.replace(/\/+/g, " ")
          path_name     = "#{process.cwd()}/#{name}"
          file_stream   = fs.createWriteStream("#{path_name}/_#{file_name}");
          params        =
            complete    : '='
            incomplete  : ' '
            width       : 20
            total       : parseInt(res.headers['content-length'], 10)
          bar           = new ProgressBar 'Downloading \t: [:bar] :percent :etas', params
          res.on 'data', (chunk) =>
            bar.tick(chunk.length)
          res.on 'end',  =>
            fs.rename "#{path_name}/_#{file_name}", "#{path_name}/#{file_name}", (err) ->
              mixin.write 'green', "Downloaded \t: #{file_name}"
              callback err, photo

          #
          # Write Mp4
          #
          res.pipe(file_stream)
        .end  (err, result) =>
          if err
            @retry++
            callback 'retry', null


  _updateManifest : (name) ->
    (input, callback) ->
      photo     = input
      arr       = []
      file      = "#{process.cwd()}/#{name}/.manifest.json"
      manifest  = require(file)
      manifest?.forEach (item) ->
        item.status = 'completed' if parseInt(item?.id) is parseInt(photo?.id)
        arr.push item
      completed = _.filter(arr, { 'status': 'completed'})
      fs.writeFile file, JSON.stringify(arr, null, 4), (err) =>
        if completed.length <= arr.length
          callback 'continue', photo
        else
          callback null, photo





module.exports = Download