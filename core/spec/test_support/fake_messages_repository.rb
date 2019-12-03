class FakeMessagesRepository
  attr_reader :messages

  def initialize
    @messages = []
  end

  def save(message)
    raise RuntimeError.new('Message must have an associated persisted incident') if message.incident.id.nil?

    if message.id.nil?
      message.id = @messages.length + 1
      message.created_at = message.created_at || DateTime.now

      @messages << message
    else
      index_to_update = @messages.find_index { |saved_message| saved_message.id == message.id }

      messages[index_to_update] = message
    end

    message
  end

  def find(id)
    @messages.detect { |message| message.id == id }
  end

  def find_by_incident_id(incident_id)
    @messages.select { |message| message.incident.id == incident_id }
  end
end
