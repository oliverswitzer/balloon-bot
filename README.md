# Balloon Bot

This Slack bot is meant to help let engineers in your organization know when master is broken. It also will help gather information for post-mortems.

# Development

To run the bot locally, you first must setup your API token. 

1. Create a `.env` file that looks like `.env.sample`. 
1. Add the `SLACK_API_TOKEN` found in Slack Dev tools
1. Run the app with `bundle exec ruby balloon-bot.rb`

