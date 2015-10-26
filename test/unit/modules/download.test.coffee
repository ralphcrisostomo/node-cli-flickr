'use strict'

fs     = require('fs')
Module = require('../../../app/modules/Download')

describe 'Module `Download`', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)
    
  it 'should get id', (done) ->
    @timeout(20000)
    name = 'test/sandbox/sample'
    @module._getId(name) (err, result) ->
      expect(result).to.equals('12345678')
      done()

#  it 'should get vimeo page', (done) ->
#    @timeout(200000)
#    @module._getVimeoPage() '5516212', (err, result) ->
#      done()

  it 'should parse html', (done) ->
    fs.readFile './test/fixtures/vimeo.page.html', 'utf8', (err, result) =>
      html = result
      @module._getRequestFiles() html, (err, result) ->
        expect(result).to.be.an('object')
        expect(result.h264).to.be.an('object')
        expect(result.h264).to.be.an('object')
        expect(result.h264.hd).to.be.an('object')
        done()

  it 'should download video', (done) ->
    @timeout(20000)
    files = require('../../fixtures/request.files.json')
    @module._downloadVideo() files, (err, result) ->
      done()





