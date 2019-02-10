class Message
  attr_accessor :id, :incident, :text, :timestamp, :channel_id

  def initialize(
    id: nil,
    incident:,
    text:,
    timestamp:,
    channel_id:
  )
    @id = id
    @incident = incident
    @text = text
    @timestamp = timestamp
    @channel_id = channel_id
  end
end