module Core
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
      return unless valid_event?(github_event)

      if active_incident?
        github_client.set_status_for_commit(
          commit_sha: github_event.pull_request.head_sha,
          status: Core::Github::Status.failure,
          more_info_url: more_info_url
        )
      else
        github_client.set_status_for_commit(
          commit_sha: github_event.pull_request.head_sha,
          status: Core::Github::Status.success
        )
      end
    end

    private def active_incident?
      current_incident != nil
    end

    private def current_incident
      incidents_repository.find_last_unresolved
    end

    private def valid_event?(github_event)
      valid_events = [
        Core::Github::PullRequestEvent::OPENED,
        Core::Github::PullRequestEvent::REOPENED,
        Core::Github::PullRequestEvent::SYNCHRONIZE
      ]

      valid_events.include? github_event.type
    end

    private def more_info_url
      initial_slack_message = messages_repository.find_by_incident_id(
        current_incident.id
      ).first

      @more_info_url ||= chat_client.url_for_message(
        timestamp: initial_slack_message.timestamp,
        channel_id: initial_slack_message.channel_id
      )
    end
  end
end
