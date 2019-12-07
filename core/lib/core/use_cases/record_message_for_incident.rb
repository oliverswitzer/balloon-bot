module Core
  class RecordMessageForIncident
    attr_reader :chat_client, :messages_repository, :incidents_repository

    def initialize(
      chat_client:,
      messages_repository:,
      incidents_repository:
    )
      @chat_client = chat_client
      @messages_repository = messages_repository
      @incidents_repository = incidents_repository
    end

    def execute(incoming_message)
      return unless !!ongoing_incident
      return if message_already_exists?(incoming_message)
      return if incoming_message.text.blank?
      return unless is_in_configured_channel?(incoming_message)

      messages_repository.save(
        Core::Message.new(
          incident: ongoing_incident,
          **incoming_message.attributes
        )
      )
    end

    private def is_in_configured_channel?(message)
      channel_name = chat_client.channel_name(message.channel_id)

      configured_channels.include? channel_name
    end

    private def configured_channels
      @configured_channels ||= [
        ENV['DEPLOYMENTS_CHANNEL'],
        ENV['INCIDENT_RESPONSE_CHANNEL']
      ]
    end

    private def message_already_exists?(incoming_message)
      !!messages_repository.find_by_timestamp(incoming_message.timestamp)
    end

    private def ongoing_incident
      incidents_repository.find_last_unresolved
    end
  end
end
