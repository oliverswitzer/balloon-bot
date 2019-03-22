require 'rufus-scheduler'

require './clients/slack/slack_client_wrapper'
require './clients/slack/balloon-bot'
require './persistence/persistence'

class App
  def self.run
    BalloonBot.instance.on(:message, Hooks::Message.new)
    BalloonBot.run

    Rufus::Scheduler.new.every '10s' do
      # `send` is a bit of a hack here, but AFAIK this is the only
      # way to get access to the slack bot client outside of
      # the BalloonBot/Hooks class
      UpdatePullRequestStatuses.new(
        incidents_repository: Persistence::INCIDENTS_REPOSITORY,
        messages_repository: Persistence::MESSAGES_REPOSITORY,
        chat_client: SlackClientWrapper.new(slack_bot_client)
      ).execute
    end
  end

  def self.slack_bot_client
    BalloonBot.instance.send(:client)
  end
end

