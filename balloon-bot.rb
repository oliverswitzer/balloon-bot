require 'slack-ruby-bot'
require 'pry'

class BalloonBot < SlackRubyBot::Bot
  command 'hold deploys' do |client, data, match|
    client.say(channel: data.channel, text: 'Holding deploys!')
    client.web_client.channels_setTopic(channel: "#balloon-bot-test", topic: '⚠️ Hold deploys ⚠️')
  end

  command 'green' do |client, data, match|
    client.say(channel: data.channel, text: 'Nice. Setting #balloon-bot-test channel topic back to green.')
    client.web_client.channels_setTopic(channel: "#balloon-bot-test", topic: ':green_balloon: :circleci-pass:')
    client.say
  end
end

BalloonBot.run
