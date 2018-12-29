class MessagesRepository
  MESSAGES = []

  def save(message)
    persisted_message = Message.new(**message.attributes, id: MESSAGES.length + 1)
    MESSAGES << persisted_message

    persisted_message
  end
end