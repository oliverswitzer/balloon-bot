class ContinueDeployments
  attr_reader :chat_client

  def initialize(chat_client:)
    @chat_client = chat_client
  end

  def execute
    chat_client.say(message: SlackClientWrapper::BACK_TO_GREEN_MESSAGE)
    chat_client.set_channel_topic(message: SlackClientWrapper::GREEN_CHANNEL_TOPIC)
  end
end