'use strict'

chai                        = require('chai')
chaiJSONSchema              = require('chai-json-schema')
superagent                  = require('superagent')
sinon                       = require('sinon')


chai.use chaiJSONSchema
expect                      = chai.expect
assert                      = chai.assert
agent                       = superagent.agent()


GLOBAL.sinon                = sinon
GLOBAL.expect               = expect
GLOBAL.assert               = assert
GLOBAL.superagent           = superagent
GLOBAL.agent                = agent

