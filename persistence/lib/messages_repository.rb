class MessagesRepository
  def save(message)
    if message.id.nil?
      record = MessageRecord.new(**MessageRecord.to_record_attributes(message))
      record.save

      message.id = record.id
    else
      MessageRecord.find(message.id).update_attributes(**MessageRecord.to_record_attributes(message))
    end

    message
  end

  def find_by_incident_id(incident_id)
    MessageRecord.where(incident_id: incident_id).map(&:to_message)
  end
end
