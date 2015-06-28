# Description
#   A Hubot script for creating memes from templates using memegen.link.
#
# Configuration:
#   None
#
# Commands:
#   hubot hello - <what the respond trigger does>
#
# Notes:
#   None
#
# Author:
#   MrSaints

MEMEGEN_API_URL = "http://memegen.link"

module.exports = (robot) ->
    robot.respond /meme list/i, (res) ->
        GetMGResult res, "/templates/", null, (obj) ->
            for template, url of obj
                res.send "#{template} (#{url})"

    robot.respond /meme (.+) --top (.+) --bottom (.+)/i, (res) ->
        template = res.match[1]
        topText = _spaceToHyphen(res.match[2])
        bottomText = _spaceToHyphen(res.match[3])

        GetMGResult res, "/#{template}/#{topText}/#{bottomText}", null, (obj) ->
            res.send "Visible: #{obj.direct.visible}"
            res.send "Masked: #{obj.direct.masked}"

_spaceToHyphen = (str) ->
    str.replace(/\s+/g, '-').toLowerCase()

GetMGResult = (res, api, params = {}, handler) ->
    res.http("#{MEMEGEN_API_URL}#{api}")
        .query(params)
        .get() (err, httpRes, body) ->
            # Improve error handling
            if err or (httpRes.statusCode isnt 200 and httpRes.statusCode isnt 302)
                res.reply "I'm unable to process your request at this time due to a server error. Please try again later."
                return res.robot.logger.error "hubot-memegen: #{body} (#{err})"

            handler JSON.parse(body)
