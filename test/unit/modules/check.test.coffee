'use strict'

Module = require('../../../app/modules/Check')

describe 'Module `Check`', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)

  it 'should create directory if it is not existing', (done) ->
    @timeout(2000)
    name = 'test/sandbox/sample'
    @module._checkDirectory(name) (err, result) ->
      done()

  it 'should check if manifest existing and create one if not', (done) ->
    @timeout(2000)
    name = 'test/sandbox/sample'
    @module._checkManifest(name) (err, result) ->
      done()

  it 'should check videos and update manifest status if existing', (done) ->
    @timeout(2000)
    name = 'test/sandbox/sample'
    @module._checkVideos(name) (err, result) ->
      done()

