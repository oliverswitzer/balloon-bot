require 'pry'

class SlackClientWrapper
  ERROR_MESSAGES = {
    already_holding: 'I\'m already holding deployments'
  }
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
      channel: lookup_channel_id(channel_name: ENV['DEPLOYMENTS_CHANNEL']),
      text: message
    )
  end

  private def lookup_channel_id(channel_name:)
    found_channel = slack_bot_client.web_client.channels_list['channels']
      .detect { |channel| channel['name'] == channel_name }

    found_channel['id'] if found_channel
  end
end