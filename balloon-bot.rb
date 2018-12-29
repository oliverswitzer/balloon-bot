require 'slack-ruby-bot'
require 'pry'
require 'dotenv'

Dotenv.load!


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

MESSAGES = []

module Hooks
  class Message
    def call(client, data)
      channel = client.web_client.channels_info(channel: data['channel'])['channel']
      if channel['name'] == 'balloon-bot-test'
        MESSAGES << data['text']
        puts "Here are all the messages that have been sent: "
        puts MESSAGES.join("\n")
      end
    end
  end
end

BalloonBot.instance.on(:message, Hooks::Message.new)
BalloonBot.run
