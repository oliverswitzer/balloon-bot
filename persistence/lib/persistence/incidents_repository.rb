module Persistence
  class IncidentsRepository
    def save(incident)
      if incident.id.nil?
        record = Persistence::IncidentRecord.create(resolved_at: incident.resolved_at)

        incident.id = record.id
        incident.created_at = record.created_at

        incident
      else
        record = Persistence::IncidentRecord.find(incident.id)
        record.resolved_at = incident.resolved_at
        record.save
      end

      incident
    end

    def find(id)
      Persistence::IncidentRecord.find(id).to_incident
    end

    def find_last_unresolved
      Persistence::IncidentRecord.where(resolved_at: nil).last&.to_incident
    end

    def find_last_n_with_messages(n = 10)
      incident_records = Persistence::IncidentRecord.includes(:messages).last(n)

      incident_records.map do |record|
        record.to_incident_with_messages(messages: record.messages)
      end
    end
  end
end
