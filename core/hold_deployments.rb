require './core/entities/incident'
require './persistence/incidents_repository'

class HoldDeployments
  attr_reader :chat_client, :incidents_repository

  def initialize(chat_client:, incidents_repository: IncidentsRepository.new)
    @chat_client = chat_client
    @incidents_repository = incidents_repository
  end

  def execute
    if incidents_repository.find_last_unresolved
      chat_client.say(message: SlackClientWrapper::ERROR_MESSAGES[:already_holding])
      return
    end

    chat_client.say(message: SlackClientWrapper::FAILURE_MESSAGE)
    chat_client.set_channel_topic(message: SlackClientWrapper::FAILURE_CHANNEL_TOPIC)

    incidents_repository.save(Incident.new)
  end
end