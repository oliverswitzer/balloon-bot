module Persistence
  class IncidentsRepository
    def save(incident)
      if incident.id.nil?
        record = Persistence::IncidentRecord.create(
          resolved_at: incident.resolved_at,
          created_at: incident.created_at
        )

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

    def find_all_resolved
      Persistence::IncidentRecord.where.not(resolved_at: nil).map(&:to_incident)
    end

    def find_by_created_at_with_messages(lower_bound: nil, upper_bound: nil)
      base_query = Persistence::IncidentRecord.includes(messages: :incident)

      base_query = base_query.where('created_at > ?', lower_bound) if lower_bound
      base_query = base_query.where('created_at < ?', upper_bound) if upper_bound

      base_query = base_query.order(created_at: :desc)

      base_query.map do |incident|
        incident.to_incident_with_messages(messages: incident.messages)
      end
    end
  end
end
