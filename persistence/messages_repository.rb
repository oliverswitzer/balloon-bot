class MessagesRepository
  attr_reader :messages

  def initialize
    @messages = []
  end

  def save(message)
    message.id = @messages.length + 1

    @messages << message

    message
  end
end