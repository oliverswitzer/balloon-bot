require 'slack-ruby-bot'
require 'pry'
require 'dotenv'

require './core/hold_deployments'
require './core/continue_deployments'
require './slack_client_wrapper'

Dotenv.load!

class BalloonBot < SlackRubyBot::Bot
  command 'hold deploys' do |client, data, match|
    HoldDeployments.new(
      chat_client: SlackClientWrapper.new(client)
    ).execute
  end

  command 'green' do |client, data, match|
    ContinueDeployments.new(
      chat_client: SlackClientWrapper.new(client)
    ).execute
  end
end

MESSAGES = []

module Hooks
  class Message
    def call(client, data)
      channel = client.web_client.channels_info(channel: data['channel'])['channel']
      if channel['name'] == ENV['DEPLOYMENTS_CHANNEL']
        MESSAGES << data['text']
        puts "Here are all the messages that have been sent: "
        puts MESSAGES.join("\n")
      end
    end
  end
end

BalloonBot.instance.on(:message, Hooks::Message.new)
BalloonBot.run
