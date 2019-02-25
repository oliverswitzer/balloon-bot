require 'clients'
require 'core'
require 'persistence'

class App
  def self.run
    BalloonBot.instance.on(:message, Hooks::Message.new)
    BalloonBot.run

    Rufus::Scheduler.new.every '10s' do
      # `send` is a bit of a hack here, but AFAIK this is the only
      # way to get access to the slack bot client outside of
      # the BalloonBot/Hooks class
      slack_bot_client = BalloonBot.instance.send(:client)

      UpdatePullRequestStatuses.new(
        incidents_repository: Persistence::INCIDENTS_REPOSITORY,
        messages_repository: Persistence::MESSAGES_REPOSITORY,
        chat_client: SlackClientWrapper.new(slack_bot_client),
        github_client: GithubClientWrapper.new
      ).execute
    end
  end
end