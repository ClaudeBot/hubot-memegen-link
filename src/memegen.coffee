# Description
#   A Hubot script for creating memes from templates using memegen.link.
#
# Configuration:
#   None
#
# Commands:
#   hubot meme create - Starts meme creation process
#   hubot meme cancel - Cancels the meme creation process
#
# Notes:
#   None
#
# Author:
#   MrSaints

MEMEGEN_API_URL = "http://memegen.link"

module.exports = (robot) ->
    _templateKeysCache = []
    _templateListCache = null

    # Delete if takes too long?
    _pending = []

    _mgAPI = (res, api, params = {}, handler) ->
        res.http("#{MEMEGEN_API_URL}#{api}")
            .query(params)
            .get() (err, httpRes, body) ->
                # TODO: Improve error handling
                if err or (httpRes.statusCode isnt 200 and httpRes.statusCode isnt 302)
                    res.reply "I'm unable to process your request at this time due to a server error. Please try again later."
                    return res.robot.logger.error "hubot-memegen-link: #{body} (#{err})"

                try
                    handler JSON.parse(body)
                catch e
                    res.robot.logger.error "hubot-memegen-link: #{e}"

    # Fetch "pending" meme using user object
    _getPending = (user) ->
        for meme, index in _pending
            return [index, meme] if meme[0].id is user.id
        return false

    _templateExist = (template) ->
        return true for key in _templateKeysCache when key is template

    _spaceToHyphen = (str) ->
        str.replace(/\s+/g, '-').toLowerCase()

    robot.respond /meme create/i, id: "memegen.new", (res) ->
        return if _getPending(res.message.user)
        createMsg = "(1/3) Creating a meme. What template should I use (reply with the key)?"

        if _templateListCache?
            res.send(_templateListCache)
            res.reply createMsg
        else
            _mgAPI res, "/templates/", null, (obj) ->
                _templateListCache = ""
                for template, url of obj
                    key = url.split "/"
                    key = key[key.length - 1]
                    _templateKeysCache.push key
                    _templateListCache += "#{template} | Key: #{key} | Example: http://memegen.link/#{key}/hello/world.jpg\n"
                # TODO: Paste results (Pastebin)?
                res.send _templateListCache
                res.reply createMsg

        _pending.push [res.message.user, false, false, false]
        res.message.done = true

    robot.respond /meme cancel/i, id: "memegen.cancel", (res) ->
        if [index, userMeme] = _getPending(res.message.user)
            _pending.splice index, 1
            res.reply "Your meme operation has been cancelled."
        else
            res.reply "You have no meme pending creation."
        res.message.done = true

    robot.hear /(.+)/i, (res) ->
        return if _pending.length is 0
        input = res.match[1]

        # Dirty solution for now
        if [index, userMeme] = _getPending(res.message.user)
            if not userMeme[1]
                if _templateExist(input)
                    _pending[index][1] = input
                    res.reply "(2/3) What should the top text be?"
                else
                    res.reply "(2/3) I'm sorry. There doesn't seem to be a meme associated with the key you have provided ('#{input}')."
            else if not userMeme[2]
                _pending[index][2] = input
                res.reply "(3/3) What should the bottom text be?"
            else if not userMeme[3]
                _mgAPI res, "/#{_pending[index][1]}/#{_spaceToHyphen(_pending[index][2])}/#{_spaceToHyphen(input)}", null, (obj) ->
                    _pending.splice index, 1
                    links = "Visible: #{obj.direct.visible}\n"
                    links += "Masked: #{obj.direct.masked}"
                    res.send links