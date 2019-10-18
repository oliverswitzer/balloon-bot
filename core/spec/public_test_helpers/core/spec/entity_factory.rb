module Core
  class EntityFactory
    def self.build_message(id: nil, text: nil, channel_id: nil, timestamp: nil, incident: nil)
      Core::Message.new(
        id: id,
        text: text || 'this is a message',
        channel_id: channel_id || Random.rand(10000).to_s,
        timestamp: timestamp || Time.now.utc.to_i.to_s,
        incident: incident || build_incident
      )
    end

    def self.build_incident(created_at: nil, resolved_at: nil)
      Core::Incident.new(
        created_at: created_at || Time.now,
        resolved_at: resolved_at || nil
      )
    end

    def self.build_incident_with_messages(created_at: nil, resolved_at: nil, messages: [])
      Core::IncidentWithMessages.new(
        created_at: created_at || Time.now,
        resolved_at: resolved_at || nil,
        messages: messages.any? ? messages : (0..2).map { build_message(text: "message ##{rand(1..9999)}" )}
      )
    end
  end
end
