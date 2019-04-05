class MessageRecord < ActiveRecord::Base
  self.table_name = 'messages'

  belongs_to :incident, class_name: 'IncidentRecord', foreign_key: 'incident_id'

  def self.to_record_attributes(message_entity)
    {
      text: message_entity.text,
      channel_id: message_entity.channel_id,
      timestamp: message_entity.timestamp,
      incident: find_or_create_incident_record(message_entity)
    }
  end

  def self.find_or_create_incident_record(message_entity)
    IncidentRecord.find_by(id: message_entity.incident.id) ||
      IncidentRecord.new(
        resolved_at: message_entity.incident.resolved_at
      )
  end
  private_class_method :find_or_create_incident_record

  def to_message
    Message.new(
      id: id,
      text: text,
      channel_id: channel_id,
      timestamp: timestamp,
      incident: Incident.new(
        id: incident.id,
        resolved_at: incident.resolved_at,
        created_at: incident.created_at
      )
    )
  end
end
