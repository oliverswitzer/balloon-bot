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
      incidents_repository: Persistence::INCIDENTS_REPOSITORY,
      messages_repository: Persistence::MESSAGES_REPOSITORY,
      github_client: GithubClientWrapper.new
    ).execute(request)
  end

  command 'green' do |client, data, match|
    ContinueDeployments.new(
      chat_client: SlackClientWrapper.new(client),
      incidents_repository: Persistence::INCIDENTS_REPOSITORY,
      github_client: GithubClientWrapper.new
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
