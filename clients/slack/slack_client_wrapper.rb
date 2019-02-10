require 'pry'

class SlackClientWrapper
  ERROR_MESSAGES = {
    already_holding: 'I\'m already holding deployments'
  }.freeze
  FAILURE_MESSAGE = 'Holding deploys!'.freeze
  BACK_TO_GREEN_MESSAGE = "Nice. Setting channel topic back to green.".freeze

  FAILURE_CHANNEL_TOPIC = '⚠️ Hold deploys ⚠️'.freeze
  GREEN_CHANNEL_TOPIC = ':green_balloon: :circleci-pass:'.freeze

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

  def url_for(message:)
    response = slack_bot_client.web_client.chat_getPermalink(
      channel: message.channel_id,
      message_ts: message.timestamp
    )

    response[:permalink]
  end

  def say(message:)
    slack_bot_client.say(
      channel: lookup_channel_id(channel_name: ENV['DEPLOYMENTS_CHANNEL']),
      text: message
    )
  end

  def channel_name(channel_id)
    channel = slack_bot_client.web_client.channels_info(channel: channel_id)[:channel]

    channel[:name]
  end

  private def lookup_channel_id(channel_name:)
    found_channel = all_channels[:channels]
      .detect { |channel| channel[:name] == channel_name }

    found_channel[:id] if found_channel
  end

  private def all_channels
    @all_channels ||= slack_bot_client.web_client.channels_list
  end
end