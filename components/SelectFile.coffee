noflo = require 'noflo'
request = require 'superagent'

selectFile = (service, target, filename, print, callback) ->
  superagent
    .post service.url+"/api/files/#{target}/#{filename}"
    .set 'X-Api-Key', service.apikey
    .send {command: 'select', print: print}
    .end (res) ->
      callback res.error

exports.getComponent = ->
  c = new noflo.Component
  c.service = null

  c.outPorts.add 'success'
  c.outPorts.add 'error'

  c.inPorts.add 'service', (event, payload) ->
    return unless event is 'data'
    c.service = payload
    # TODO: validate input, error if wrong
  c.inPorts.add 'print', (event, payload) ->
    return unless event is 'data'
    c.printAtOnce = payload
  c.inPorts.add 'filename', (event, payload) ->
    return unless event is 'data'

    # FIXME: don't hardcode local
    selectFile c.service, 'local', payload, c.printAtOnce, (err, res) ->
      if err
        c.outPorts.error.send err
        c.outPorts.error.disconnect()
        c.outPorts.success.send false
      else
        c.outPorts.success.send true

  return c
