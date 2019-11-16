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

    def find_all_resolved_grouped_by_duration
      rows = ActiveRecord::Base.connection.execute(
        <<~SQL
          SELECT date_trunc('month', created_at) as month_of_year,
                 SUM(EXTRACT(EPOCH FROM (resolved_at - created_at))) as total_duration_in_seconds
          FROM incidents
          WHERE created_at > now() - interval '1 year'
          GROUP BY date_trunc('month', created_at)
          ORDER BY month_of_year ASC
        SQL
      )

      rows.map do |row|
        {
          month: DateTime.parse(row["month_of_year"]),
          total_duration_in_milliseconds: row["total_duration_in_seconds"]*1000
        }
      end
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
