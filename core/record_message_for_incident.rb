require './persistence/messages_repository'
require './core/entities/message'

class RecordMessageForIncident
  attr_reader :chat_client, :messages_repository

  def initialize(chat_client:, messages_repository: MessagesRepository.new)
    @chat_client = chat_client
    @messages_repository = messages_repository
  end

  def execute(text:, channel:)
    if channel == ENV['DEPLOYMENTS_CHANNEL']
      messages_repository.save(
        Message.new(
          text: text
        )
      )
    end
  end
end