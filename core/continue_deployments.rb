class ContinueDeployments
  attr_reader :chat_client, :incidents_repository

  def initialize(chat_client:, incidents_repository: IncidentsRepository.new)
    @chat_client = chat_client
    @incidents_repository = incidents_repository
  end

  def execute
    chat_client.say(message: SlackClientWrapper::BACK_TO_GREEN_MESSAGE)
    chat_client.set_channel_topic(message: SlackClientWrapper::GREEN_CHANNEL_TOPIC)

    incident = incidents_repository.find_last_unresolved
    incidents_repository.save(Incident.new(id: incident.id, resolved_at: Time.now))
  end
end