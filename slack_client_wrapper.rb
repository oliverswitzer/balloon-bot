class SlackClientWrapper
  FAILURE_MESSAGE = 'Holding deploys!'
  BACK_TO_GREEN_MESSAGE = "Nice. Setting channel topic back to green."

  FAILURE_CHANNEL_TOPIC = '⚠️ Hold deploys ⚠️'
  GREEN_CHANNEL_TOPIC = ':green_balloon: :circleci-pass:'

  attr_reader :slack_bot_client

  def initialize(slack_bot_client)
    @slack_bot_client = slack_bot_client
  end

  def set_channel_topic(message:)

    slack_bot_client.web_client.channels_setTopic(
      channel: "##{ENV['DEPLOYMENTS_CHANNEL']}",
      topic: message
    )
  end

  def say(message:)
    slack_bot_client.say(
      channel: "##{ENV['DEPLOYMENTS_CHANNEL']}",
      text: message
    )
  end
end