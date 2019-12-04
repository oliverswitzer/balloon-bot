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
      unresolved_incident = incidents_repository.find_last_unresolved

      return if !!messages_repository.find_by_timestamp(incoming_message.timestamp)

      if unresolved_incident && is_in_configured_channel?(incoming_message)
        messages_repository.save(
          Core::Message.new(
            incident: unresolved_incident,
            **incoming_message.attributes
          )
        )
      end
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
  end
end
