require './core/entities/incident'
require './persistence/incidents_repository'

class HoldDeployments
  attr_reader :chat_client, :incidents_repository, :github_client

  def initialize(chat_client:, incidents_repository: IncidentsRepository.new, github_client:)
    @chat_client = chat_client
    @incidents_repository = incidents_repository
    @github_client = github_client
  end

  def execute
    if incidents_repository.find_last_unresolved
      chat_client.say(message: SlackClientWrapper::ERROR_MESSAGES[:already_holding])
      return
    end

    chat_client.say(message: SlackClientWrapper::FAILURE_MESSAGE)
    chat_client.set_channel_topic(message: SlackClientWrapper::FAILURE_CHANNEL_TOPIC)

    github_client.open_pull_requests.each do |pull_request|
      github_client.set_status_for_commit(
        commit_sha: pull_request.head_sha,
        state: GithubClientWrapper::FAILURE_STATE,
        context: 'Master is broken',
        description: 'Do not merge into master'
      )
    end

    incidents_repository.save(Incident.new)
  end
end
