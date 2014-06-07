noflo = require 'noflo'
request = require 'superagent'

exports.getComponent = ->
  c = new noflo.Component
  c.service = null

  c.outPorts.add 'connected'
  c.outPorts.add 'error'

  c.inPorts.add 'service', (event, payload) ->
    return unless event is 'data'
    c.service = payload
    # TODO: validate input, error if wrong
  c.inPorts.add 'connect', (event, payload) ->
    return unless event is 'data'
    superagent
    .get c.service.url+'/api/printer'
    .set 'X-Api-Key', c.service.apikey
    .end (res) =>
      if res.error? and res.error
        c.outPorts.error.send res.error
        c.outPorts.connected.send false
      else
        c.outPorts.connected.send true
   # TODO: check connectivity continiously
   # XXX: will give 409 error if printer is not running
  return c
