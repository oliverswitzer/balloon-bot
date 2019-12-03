module Persistence
  class MessagesRepository
    def save(message)
      raise RuntimeError.new('Message must have an associated persisted incident') if message.incident.id.nil?

      if message.id.nil?
        record = Persistence::MessageRecord.new(**Persistence::MessageRecord.to_record_attributes(message))
        record.save

        message.id = record.id
      else
        Persistence::MessageRecord.find(message.id).update(**Persistence::MessageRecord.to_record_attributes(message))
      end

      message
    end

    def find_by_incident_id(incident_id)
      Persistence::MessageRecord.where(incident_id: incident_id)
        .order(created_at: :asc)
        .map(&:to_message)
    end
  end
end
