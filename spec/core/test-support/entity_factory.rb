class EntityFactory
  def self.build_message(text: nil, channel_id: nil, timestamp: nil, incident: nil)
    Message.new(
      text: text || 'yo',
      channel_id: channel_id || '456',
      timestamp: timestamp || '123',
      incident: incident || Incident.new
    )
  end

  def self.build_incident(created_at: nil, resolved_at: nil)
    Incident.new(
      created_at: created_at || Time.now,
      resolved_at: resolved_at || nil
    )
  end
end