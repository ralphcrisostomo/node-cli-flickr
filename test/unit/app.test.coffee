'use strict'

Module = require('../../app/app')

describe 'App', ->

  beforeEach ->
    name = name = 'test/sandbox/sample'
    @module = new Module(name)

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)