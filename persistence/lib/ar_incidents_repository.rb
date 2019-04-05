class ArIncidentsRepository
  def save(incident)
    if incident.id.nil?
      record = IncidentRecord.create(resolved_at: incident.resolved_at)

      incident.id = record.id
      incident.created_at = record.created_at

      incident
    else
      record = IncidentRecord.find(incident.id)
      record.resolved_at = incident.resolved_at
      record.save
    end

    incident
  end

  def find(id)
    record = IncidentRecord.find(id)

    Incident.new(resolved_at: record.resolved_at, created_at: record.created_at)
  end

  def find_last_unresolved
    record = IncidentRecord.where(resolved_at: nil).last

    Incident.new(id: record.id, resolved_at: record.resolved_at, created_at: record.created_at) if record
  end
end
