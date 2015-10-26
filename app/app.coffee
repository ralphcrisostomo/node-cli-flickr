'use strict'

Flickr      = require('flickrapi')
Check       = require('./modules/check')
Download    = require('./modules/download')
async       = require('async')
commander   = require('commander')
path        = require('path')
rootPath    = path.normalize(__dirname + '/..')
dotenv      = require('dotenv')
dotenv.config({path:"#{rootPath}/env/#{process.env.NODE_ENV}"})



# Psuedocode
# ------------------------------
# - Detect directory
# - Detect manifest
# - Detect videos

class App

  constructor : (name) ->
    check     = new Check()
    download  = new Download()
    config    =
      api_key : process.env.FLICKR_API_KEY
      secret  : process.env.FLICKR_SECRET

    Flickr.tokenOnly config, (error, flickr) ->
      async.series [
        check.run(flickr, name)
        download.run(flickr, name)
      ], (err, result) ->



module.exports = App