class ArMessagesRepository
  def save(message)
    if message.id.nil?
      record = MessageRecord.create(
        text: message.text,
        channel_id: message.channel_id,
        timestamp: message.timestamp,
        incident: find_or_create_incident_record(message)
      )

      message.id = record.id
    else
      record = MessageRecord.find(message.id)

      record.text = message.text
      record.timestamp = message.timestamp
      record.channel_id = message.channel_id
      record.incident = find_or_create_incident_record(message)

      record.save
    end

    message
  end

  def find_by_incident_id(incident_id)
    records = MessageRecord.where(incident_id: incident_id)

    records.map do |record|
      Message.new(
        id: record.id,
        text: record.text,
        channel_id: record.channel_id,
        timestamp: record.timestamp,
        incident: Incident.new(
          id: record.incident.id,
          resolved_at: record.incident.resolved_at,
          created_at: record.incident.created_at
        )
      )
    end
  end

  private def find_or_create_incident_record(message)
    IncidentRecord.find_by(id: message.incident.id) ||
      IncidentRecord.new(
        resolved_at: message.incident.resolved_at
      )
  end
end
