require './clients/github/github_client_wrapper'
require './clients/github/status'
require './persistence/incidents_repository'
require './persistence/messages_repository'

class UpdatePullRequestStatuses
  attr_reader :github_client, :chat_client, :incidents_repository, :messages_repository

  def initialize(
    github_client: GithubClientWrapper.new,
    chat_client:,
    incidents_repository: IncidentsRepository.new,
    messages_repository: MessagesRepository.new
  )
    @github_client = github_client
    @chat_client = chat_client
    @incidents_repository = incidents_repository
    @messages_repository = messages_repository
  end

  def execute
    if active_incident?
      initial_slack_message = messages_repository.find_by_incident_id(
        current_incident.id
      ).first

      more_info_url = chat_client.url_for_message(
        timestamp: initial_slack_message.timestamp,
        channel_id: initial_slack_message.channel_id
      )

      puts 'Ongoing incident: marking all open pull requests as failing'
      fail_open_pull_requests(more_info_url)
    end
  end


  private def fail_open_pull_requests(more_info_url)
    github_client.open_pull_requests.each do |pull_request|
      puts "Marking PR for branch #{pull_request.branch} as failing"
      github_client.set_status_for_commit(
        commit_sha: pull_request.head_sha,
        status: Github::Status.failure,
        more_info_url: more_info_url
      )
    end
  end

  private def active_incident?
    current_incident != nil
  end

  private def current_incident
    incidents_repository.find_last_unresolved
  end
end
