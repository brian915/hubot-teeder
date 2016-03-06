module.exports = (robot) ->

  key = 'teeder_status'
  maxMessageLength = 140
  maxMessageHistory = 100
  defaultResponseSize = 5

  robot.respond /status (.*)/i, (msg) ->
    message =  msg.match[1].trim().substring(0,maxMessageLength)
    if message.match /list/
      getStatus(msg)
    else
      msg.send "OK, got it: " + message
      putStatus(message)

  robot.respond /drop/i, (msg) ->
    dropStatus(msg)

  robot.respond /list/i, (msg) ->
    getStatus(msg)

  putStatus = (message, text) ->
    data = robot.brain.get(key)
    unless data instanceof Array
      data = []
    data.unshift message
    robot.brain.set(key, data.slice(0, maxMessageHistory))

  getStatus = (msg) ->
    data = robot.brain.get(key).slice(0,defaultResponseSize).reverse()
    for message in data
      msg.send(message)

  dropStatus = (msg) ->
    data = robot.brain.get(key).shift()
    getStatus(msg)


    
