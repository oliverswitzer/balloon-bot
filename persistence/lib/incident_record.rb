class IncidentRecord < ActiveRecord::Base
  self.table_name = 'incidents'

  def to_incident
    Incident.new(id: id, resolved_at: resolved_at, created_at: created_at)
  end
end
