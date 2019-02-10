class EntityFactory
  def self.build_message(text: nil, channel_id: nil, timestamp: nil, incident: nil)
    Message.new(
      text: text || 'yo',
      channel_id: channel_id || '456',
      timestamp: timestamp || '123',
      incident: incident || Incident.new
    )
  end
end