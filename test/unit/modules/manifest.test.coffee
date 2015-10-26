'use strict'

Module = require('../../../app/modules/Manifest')

describe 'Module `Manifest`', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)

#  it 'should create a manifest', (done) ->
#    @timeout(200000)
#    @module.create('jasonmagbanua', 1) (err, result) ->
#      done()