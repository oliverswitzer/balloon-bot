require 'slack-ruby-bot'
require 'pry'
require 'dotenv'

require './core/hold_deployments'
require './core/continue_deployments'
require './core/record_message_for_incident'
require './slack_client_wrapper'

require './persistence/messages_repository'

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
      channel_name = client.web_client.channels_info(channel: data['channel'])['channel']['name']

      RecordMessageForIncident.new(
        chat_client: SlackClientWrapper.new(client)
      ).execute(text: data['text'], channel: channel_name)

      puts 'all messages: '
      puts MessagesRepository::MESSAGES.map(&:text).join("\n")
    end
  end
end

BalloonBot.instance.on(:message, Hooks::Message.new)
BalloonBot.run
