module Persistence
  class MessagesRepository
    def save(message)
      if message.id.nil?
        record = Persistence::MessageRecord.new(**Persistence::MessageRecord.to_record_attributes(message))
        record.save

        message.id = record.id
      else
        Persistence::MessageRecord.find(message.id).update_attributes(**Persistence::MessageRecord.to_record_attributes(message))
      end

      message
    end

    def find_by_incident_id(incident_id)
      Persistence::MessageRecord.where(incident_id: incident_id).map(&:to_message)
    end
  end
end
