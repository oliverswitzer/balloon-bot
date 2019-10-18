module Persistence
  class IncidentRecord < ActiveRecord::Base
    self.table_name = 'incidents'

    has_many :messages, class_name: 'Persistence::MessageRecord', foreign_key: 'incident_id'

    def to_incident
      Core::Incident.new(id: id, resolved_at: resolved_at, created_at: created_at)
    end

    def to_incident_with_messages(messages:)
      Core::IncidentWithMessages.new(
        id: id,
        resolved_at: resolved_at,
        created_at: created_at,
        messages: messages.map(&:to_message)
      )
    end
  end
end
