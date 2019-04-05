class MessagesRepository
  attr_reader :messages

  def initialize
    @messages = []
  end

  def find_by_incident_id(incident_id)
    @messages.select { |message| message.incident.id == incident_id }
  end

  def save(message)
    if message.id.nil?
      message.id = @messages.length + 1

      @messages << message
    else
      index_to_update = @messages.find_index { |saved_message| saved_message.id == message.id }

      messages[index_to_update] = message
    end

    message
  end
end