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

    def execute(request)
      unresolved_incident = incidents_repository.find_last_unresolved

      if unresolved_incident && is_in_configured_channel?(request)
        messages_repository.save(
          Core::Message.new(
            text: request.message[:text],
            incident: unresolved_incident,
            timestamp: request.message[:timestamp],
            channel_id: request.message[:channel_id]
          )
        )
      end
    end

    class Request < Dry::Struct
      attribute :message, Types::Hash.schema(
        text: Types::Strict::String.optional,
        timestamp: Types::Strict::String,
        channel_id: Types::Strict::String
      )
    end

    private def is_in_configured_channel?(request)
      channel_name = chat_client.channel_name(request.message[:channel_id])

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
