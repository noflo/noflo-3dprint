noflo = require 'noflo'
request = require 'superagent'

exports.getComponent = ->
  c = new noflo.Component
  c.service = null

  c.outPorts.add 'out'
  c.outPorts.add 'error'

  c.inPorts.add 'service', (event, payload) ->
    return unless event is 'data'
    c.service = payload
    # TODO: validate input, error if wrong

  c.inPorts.add 'in', (event, payload) ->
    return unless event is 'data'

    superagent
    .post c.service.url+'/api/printer/printhead'
    .set 'X-Api-Key', c.service.apikey
    .type 'json'
    .send payload
    .end (res) =>
      if res.error? and res.error
        c.outPorts.error.send res.error
      else
        c.outPorts.out.send payload

  return c
