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

  help do
    title 'BalloonBot'
    desc 'This Slack bot is meant to help let engineers in your organization know when master is broken.'

    command 'hold deploys' do
      desc 'will change the channel topic to a failing icon and prevent merges into master via a failing github status check. It is best to provide a reason for the failure'
      long_desc 'Usage: "@balloonbot hold deploys <optional description of the issue>"'
    end

    command 'green' do
      desc 'will change the channel topic back to a passing icon and allow merges into master again'
      long_desc('Usage: "@balloonbot green"')
    end
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
