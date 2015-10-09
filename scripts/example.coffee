# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  botname = process.env.HUBOT_SLACK_BOTNAME
  plusplus_re = /@([a-z0-9_\-\.]+)\+{2,}/ig
  minusminus_re = /@([a-z0-9_\-\.]+)\-{2,}/ig
  plusplus_minusminus_re = /@([a-z0-9_\-\.]+)[\+\-]{2,}/ig
  
  robot.hear plusplus_minusminus_re, (msg) ->
     res = ''
     while (match = plusplus_re.exec(msg.message))
         user = match[1].replace(/\-+$/g, '')
         count = (robot.brain.get(user) or 0) + 1
         robot.brain.set user, count
         res += "@#{user}++ [woot! now at #{count}]\n"
     while (match = minusminus_re.exec(msg.message))
         user = match[1].replace(/\-+$/g, '')
         count = (robot.brain.get(user) or 0) - 1
         robot.brain.set user, count
         res += "@#{user}-- [ouch! now at #{count}]\n"
     msg.send res.replace(/\s+$/g, '')

  robot.hear /// #{botname} \s+ @([a-z0-9_\-\.]+) ///i, (msg) ->
     user = msg.match[1].replace(/\-+$/g, '')
     count = robot.brain.get(user)
     if count != null
         point_label = if count == 1 then "point" else "points"
         msg.send "@#{user}: #{count} " + point_label
     else
         msg.send "@#{user} has no karma"

  robot.hear /// #{botname} \s+ leaderboard ///i, (msg) ->
     users = robot.brain.data._private
     tuples = []
     for username, score of users
        tuples.push([username, score])

     if tuples.length == 0
        msg.send "The lack of karma is too damn high!"
        return

     tuples.sort (a, b) ->
        if a[1] > b[1]
           return -1
        else if a[1] < b[1]
           return 1
        else
           return 0

     str = ''
     for i in [0...Math.min(5, tuples.length)]
        username = tuples[i][0]
        points = tuples[i][1]
        point_label = if points == 1 then "point" else "points"
        leader = if i == 0 then "All hail supreme leader!" else ""
        newline = if i < Math.min(3, tuples.length) - 1 then '\n' else ''
        str += "##{i+1} @#{username} [#{points} " + point_label + "] " + leader + newline
     msg.send(str)

  #
  # robot.respond /open the (.*) doors/i, (msg) ->
  #   doorType = msg.match[1]
  #   if doorType is "pod bay"
  #     msg.reply "I'm afraid I can't let you do that."
  #   else
  #     msg.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (msg) ->
  #   msg.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (msg) ->
  #   msg.send msg.random lulz
  #
  # robot.topic (msg) ->
  #   msg.send "#{msg.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (msg) ->
  #   msg.send msg.random enterReplies
  # robot.leave (msg) ->
  #   msg.send msg.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (msg) ->
  #   unless answer?
  #     msg.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   msg.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (msg) ->
  #   setTimeout () ->
  #     msg.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (msg) ->
  #   if annoyIntervalId
  #     msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   msg.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (msg) ->
  #   if annoyIntervalId
  #     msg.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     msg.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, msg) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if msg?
  #     msg.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (msg) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     msg.reply "I'm too fizzy.."
  #
  #   else
  #     msg.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (msg) ->
  #   robot.brain.set 'totalSodas', 0
  #   robot.respond 'zzzzz'
