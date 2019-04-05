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
    incident = incidents_repository.find_last_unresolved

    if incident && is_in_deployments_channel?(request)
      messages_repository.save(
        Message.new(
          text: request.message[:text],
          incident: incident,
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


  private def is_in_deployments_channel?(request)
    channel_name = chat_client.channel_name(request.message[:channel_id])

    channel_name == ENV['DEPLOYMENTS_CHANNEL']
  end
end
