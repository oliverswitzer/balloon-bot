require 'slack-ruby-bot'
require 'rufus-scheduler'

require './core/hold_deployments'
require './core/continue_deployments'
require './core/record_message_for_incident'
require './core/update_pull_request_statuses'
require './clients/slack/slack_client_wrapper'
require './clients/github/github_client_wrapper'

require './persistence/messages_repository'
require './persistence/incidents_repository'

Dotenv.load! unless ENV['ENVIRONMENT'] == 'production'

MESSAGES_REPOSITORY = MessagesRepository.new
INCIDENTS_REPOSITORY = IncidentsRepository.new

def parse_message(data)
  {
    message: {
      text: data[:text],
      channel_id: data[:channel],
      timestamp: data[:ts]
    }
  }
end

class BalloonBot < SlackRubyBot::Bot
  command 'hold deploys' do |client, data, match|
    request = HoldDeployments::Request.new(parse_message(data))

    HoldDeployments.new(
      chat_client: SlackClientWrapper.new(client),
      incidents_repository: INCIDENTS_REPOSITORY
    ).execute(request)
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
      request = RecordMessageForIncident::Request.new(
        parse_message(data)
      )

      RecordMessageForIncident.new(
        chat_client: SlackClientWrapper.new(client),
        incidents_repository: INCIDENTS_REPOSITORY,
        messages_repository: MESSAGES_REPOSITORY
      ).execute(request)
    end
  end
end

scheduler = Rufus::Scheduler.new
scheduler.every '10s' do
  # `send` is a bit of a hack here, but AFAIK this is the only
  # way to get access to the slack bot client outside of
  # the BalloonBot/Hooks class
  slack_bot_client = BalloonBot.instance.send(:client)

  UpdatePullRequestStatuses.new(
    incidents_repository: INCIDENTS_REPOSITORY,
    messages_repository: MESSAGES_REPOSITORY,
    chat_client: SlackClientWrapper.new(slack_bot_client)
  ).execute
end

BalloonBot.instance.on(:message, Hooks::Message.new)
BalloonBot.run

