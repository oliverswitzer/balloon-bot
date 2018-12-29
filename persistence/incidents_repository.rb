class IncidentsRepository
  INCIDENTS = []

  def save(incident)
    persisted_incident = Incident.new(
      **incident.attributes,
      id: INCIDENTS.length + 1,
      created_at: Time.now
    )

    INCIDENTS << persisted_incident

    persisted_incident
  end
end