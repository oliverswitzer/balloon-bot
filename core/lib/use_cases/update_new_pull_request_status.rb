class UpdateNewPullRequestStatus
  attr_reader :github_client, :chat_client, :incidents_repository, :messages_repository

  def initialize(
    github_client:,
      chat_client:,
      incidents_repository:,
      messages_repository:
  )
    @github_client = github_client
    @chat_client = chat_client
    @incidents_repository = incidents_repository
    @messages_repository = messages_repository
  end

  def execute(github_event:)
    return unless pr_is_being_opened?(github_event)

    if active_incident?
      initial_slack_message = messages_repository.find_by_incident_id(
        current_incident.id
      ).first

      more_info_url = chat_client.url_for_message(
        timestamp: initial_slack_message.timestamp,
        channel_id: initial_slack_message.channel_id
      )

      github_client.set_status_for_commit(
        commit_sha: github_event.pull_request.head_sha,
        status: Github::Status.failure,
        more_info_url: more_info_url
      )
    else
      github_client.set_status_for_commit(
        commit_sha: github_event.pull_request.head_sha,
        status: Github::Status.success
      )
    end
  end

  private def active_incident?
    current_incident != nil
  end

  private def current_incident
    incidents_repository.find_last_unresolved
  end

  private def pr_is_being_opened?(github_event)
    (github_event.type == PullRequestEvent::OPENED ||
      github_event.type == PullRequestEvent::REOPENED)
  end
end
