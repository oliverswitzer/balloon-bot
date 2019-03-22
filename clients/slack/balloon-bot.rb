require 'slack-ruby-bot'

require './core/hold_deployments'
require './core/continue_deployments'
require './core/record_message_for_incident'
require './clients/slack/slack_client_wrapper'
require './clients/github/github_client_wrapper'

require './persistence/persistence'

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
      incidents_repository: Persistence::INCIDENTS_REPOSITORY
    ).execute(request)
  end

  command 'green' do |client, data, match|
    ContinueDeployments.new(
      chat_client: SlackClientWrapper.new(client),
      incidents_repository: Persistence::INCIDENTS_REPOSITORY
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
        incidents_repository: Persistence::INCIDENTS_REPOSITORY,
        messages_repository: Persistence::MESSAGES_REPOSITORY
      ).execute(request)
    end
  end
end
