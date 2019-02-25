class MessagesRepository
  attr_reader :messages

  def initialize
    @messages = []
  end

  def find_by_incident_id(incident_id)
    @messages.select { |message| message.incident.id == incident_id }
  end

  def save(message)
    message.id = @messages.length + 1

    @messages << message

    message
  end
end