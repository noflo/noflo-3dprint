noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.description =
    service: "cura-server"

  checkSend = ->
    d = c.description
    if d.url? and d.apikey?
      c.outPorts.out.send d
      c.outPorts.out.disconnect()

  c.outPorts.add 'out'

  c.inPorts.add 'url', (event, payload) ->
    return unless event is 'data'
    c.description.url = payload
    checkSend()
  c.inPorts.add 'apikey', (event, payload) ->
    return unless event is 'data'
    c.description.apikey = payload
    checkSend()

  c
