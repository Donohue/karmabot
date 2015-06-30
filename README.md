# karmabot

![Karmabot screenshot](/karmabot.png "Karmabot in action")

Karmabot is a chat bot built on the [Hubot](http://hubot.github.com/) framework for use with [Slack](https://slack.com). 

## Getting Started

#### Testing your bot locally

- `HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd ./bin/hubot --adapter slack`

#### Deploying to Heroku

This is a modified set of instructions based on the [Slack hubot-slack repo](https://github.com/slackhq/hubot-slack/blob/master/README.md)

- Install [heroku toolbelt](https://toolbelt.heroku.com/) if you haven't already.
- `heroku create my-company-slackbot`
- `heroku addons:add redistogo:nano`
- Activate the Hubot service on your ["Team Services"](http://my.slack.com/services/new/hubot) page inside Slack.
- Add the config variables:

        % heroku config:add HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd
        % heroku config:add HUBOT_SLACK_BOTNAME=karmabot
        % heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s  | grep web_url | cut -d= -f2)
                 
- Deploy and start the bot:

        % git push heroku master

- Profit!

## Configuration

This adapter uses the following environment variables:

 - `HUBOT_SLACK_TOKEN` - this is the API token for the Slack user you would like to run Hubot under.
 - `HUBOT_SLACK_BOTNAME` - this is only for the karmabot leaderboard, it was required for earlier Slack Hubot integrations.
 - `HUBOT_HEROKU_KEEPALIVE_URL` - keepalive

To add or remove your bot from specific channels or private groups, you can use the /kick and /invite slash commands that are built into Slack.

## Copyright

Copyright &copy; Slack Technologies, Inc. MIT License; see LICENSE for further details.

