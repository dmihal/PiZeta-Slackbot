#description

request = require 'request'
cheerio = require 'cheerio'

austinURL = 'http://www.austinliquors.com/featured-items.html'

module.exports = (robot) ->

  robot.respond /is keystone on sale/gi, (msg) ->
    austin msg
  robot.respond /[\w\d ]*cheapest beer/gi, (msg) ->
    cheapest msg
    
cheapest = (msg) ->
  request uri: austinURL, (err, response, body) =>
    $ = cheerio.load body
    minprice = 100
    mintext = ""
    isBeer = false
    $("#simplelists-description p").each( ->
      el = $(this)
      text = el.text()
      
      if (isBeer)
        regex = /(\d+) packs?[A-Za-z0-9 &\"]* \$([\d\.]+)/g
        
        result = regex.exec(text)
        if(result)
          price = (result[2] / result[1]).toFixed(2)
          if (price < minprice)
            minprice = price
            mintext = text + " ($" + price + "/beer)"
      else
        if (text == "BEER")
          isBeer = true
    )
    msg.send "The cheapest beer at Austin is " + mintext;

austin = (msg) ->
  request uri: austinURL, (err, response, body) =>
    $ = cheerio.load body
    
    regex = /Keystone[\w ]*\$([\d\.]+)/g
    specials = $('#simplelists-description').text()

    result = regex.exec(specials)
    
    if result
      msg.send "Keystone is on sale at Austin for $"+result[1]
    else
      msg.send "Keystone is not on sale"