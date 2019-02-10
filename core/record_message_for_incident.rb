require './persistence/messages_repository'
require './core/entities/message'
require './types'

class RecordMessageForIncident
  attr_reader :chat_client, :messages_repository, :incidents_repository

  def initialize(
    chat_client:,
      messages_repository: MessagesRepository.new,
      incidents_repository: IncidentsRepository.new
  )
    @chat_client = chat_client
    @messages_repository = messages_repository
    @incidents_repository = incidents_repository
  end

  def execute(request)
    incident = incidents_repository.find_last_unresolved
    channel_name = chat_client.channel_name(request.message[:channel_id])

    if channel_name == ENV['DEPLOYMENTS_CHANNEL'] && incident
      messages_repository.save(
        Message.new(
          text: request.message[:text],
          incident: incident,
          timestamp: request.message[:timestamp],
          channel_id: request.message[:channel_id]
        )
      )

      log_current_state
    end
  end

  private

  class Request < Dry::Struct
    attribute :message, Types::Hash.schema(
      text: Types::Strict::String,
      timestamp: Types::Strict::String,
      channel_id: Types::Strict::String
    )
  end

  def log_current_state
    puts 'All messages:'
    puts "count: #{messages_repository.messages.size}"
    p messages_repository.messages
    puts "All incidents: "
    p incidents_repository.incidents
  end
end