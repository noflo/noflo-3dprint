noflo = require 'noflo'
request = require 'superagent'

exports.getComponent = ->
  c = new noflo.Component
  c.service = null

  c.inPorts.add 'service', (event, payload) ->
    return unless event is 'data'
    c.service = payload
    # TODO: validate input, error if wrong
  c.inPorts.add 'connect', (event, payload) ->
    return unless event is 'data'
    superagent
    .get c.service.url+'/api/files'
    .set 'X-Api-Key', c.service.apikey
    .end (res) ->
      if res.error?
        c.outPorts.error.send res.error
        c.outPorts.connected.send false
      else
        c.outPorts.connected.send true
   # TODO: check connectivity continiously

  c.outPorts.add 'connected'
  c.outPorts.add 'error'

  return c
