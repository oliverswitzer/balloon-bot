require './persistence/messages_repository'
require './core/entities/message'

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

  def execute(text:, channel:)
    incident = incidents_repository.find_last_unresolved

    if channel == ENV['DEPLOYMENTS_CHANNEL'] && incident
      messages_repository.save(
        Message.new(
          text: text,
          incident: incident
        )
      )

      puts 'All messages:'
      puts "count: #{MESSAGES_REPOSITORY.messages.size}"
      puts MESSAGES_REPOSITORY.messages.map(&:text).join("\n")
    end
  end
end