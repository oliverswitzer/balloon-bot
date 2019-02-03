require 'slack-ruby-bot'
require 'pry'
require 'dotenv'

require './core/hold_deployments'
require './core/continue_deployments'
require './core/record_message_for_incident'
require './clients/slack/slack_client_wrapper'
require './clients/slack/slack_message'
require './clients/github/github_client_wrapper'

require './persistence/messages_repository'
require './persistence/incidents_repository'

Dotenv.load!

MESSAGES_REPOSITORY = MessagesRepository.new
INCIDENTS_REPOSITORY = IncidentsRepository.new

class BalloonBot < SlackRubyBot::Bot
  command 'hold deploys' do |client, data, match|
    message = SlackMessage.new(
      timestamp: data[:ts],
      channel_id: data[:channel]
    )

    HoldDeployments.new(
      chat_client: SlackClientWrapper.new(client),
      incidents_repository: INCIDENTS_REPOSITORY,
      github_client: GithubClientWrapper.new
    ).execute(
      HoldDeployments::Request.new(
        triggered_by: message
      )
    )
  end

  command 'green' do |client, data, match|
    ContinueDeployments.new(
      chat_client: SlackClientWrapper.new(client),
      incidents_repository: INCIDENTS_REPOSITORY
    ).execute
  end
end

module Hooks
  class Message
    def call(client, data)
      channel_name = client.web_client.channels_info(channel: data['channel'])['channel']['name']

      RecordMessageForIncident.new(
        chat_client: SlackClientWrapper.new(client),
        incidents_repository: INCIDENTS_REPOSITORY,
        messages_repository: MESSAGES_REPOSITORY

      ).execute(text: data['text'], channel: channel_name)
    end
  end
end

BalloonBot.instance.on(:message, Hooks::Message.new)
BalloonBot.run
