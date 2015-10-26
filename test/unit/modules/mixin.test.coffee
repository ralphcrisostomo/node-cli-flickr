'use strict'

Module = require('../../../app/modules/Mixin')

describe 'Module `Mixin`', ->

  beforeEach ->
    @module = Module

  afterEach ->
    @module = null

  it 'should be an instance', ->
