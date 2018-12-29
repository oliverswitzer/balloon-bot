class MessagesRepository
  attr_reader :messages
  def initialize
    @messages = []
  end

  def save(message)
    persisted_message = Message.new(**message.attributes, id: @messages.length + 1)

    @messages << persisted_message

    persisted_message
  end
end