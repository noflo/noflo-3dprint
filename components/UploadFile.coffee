noflo = require 'noflo'
request = require 'superagent'

# FIXME: use superagent instead, for nodejs compat
uploadFile = (service, location, filename, data, callback) ->
  data = new Blob [data], {type: 'application/octet-stream'}
  formData = new FormData()
  formData.append 'file', data, filename

  xhr = new XMLHttpRequest()
  xhr.open 'POST', service.url+'/api/files/'+location, true
  xhr.setRequestHeader 'X-Api-Key', service.apikey
  xhr.onload = () ->
    if xhr.status == 201
      return callback null, xhr.response
    else
      return callback xhr.response, null
  xhr.send formData

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
    if event is 'begingroup'
      c.outPorts.out.beginGroup payload
    if event is 'endgroup'
      c.outPorts.out.endGroup payload

    return unless event is 'data'

    # TODO: take filename as group?
    uploadFile c.service, 'local', 'noflo.gcode', payload, (err, result) ->
      if err
        c.outPorts.error.send err
        c.outPorts.error.disconnect()
      else
        c.outPorts.out.send result
        c.outPorts.out.disconnect()

  return c
