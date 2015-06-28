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

module.exports = (robot) ->
    robot.respond /hello/, (res) ->
        res.reply "hello!"