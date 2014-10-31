#description

request = require 'request'
cheerio = require 'cheerio'

module.exports = (robot) ->

  robot.respond /is keystone on sale/i, (msg) ->
    austin msg

austin = (msg) ->
  request uri: 'http://www.austinliquors.com/featured-items.html', (err, response, body) =>
    $ = cheerio.load body
    
    regex = /Keystone[\w ]*\$([\d\.]+)/g
    specials = $('#simplelists-description').text()

    result = regex.exec(specials)
    
    if result
      msg.send "Keystone is on sale at Austin for $"+result[1]
    else
      msg.send "Keystone is not on sale"