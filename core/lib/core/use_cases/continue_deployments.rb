module Core
  class ContinueDeployments
    attr_reader :chat_client, :github_client, :incidents_repository

    BACK_TO_GREEN_MESSAGE = 'Nice. Setting channel topic back to green.'.freeze
    DEFAULT_CHANNEL_TOPIC = 'Master is green, feel free to merge and deploy.'.freeze

    def initialize(
      chat_client:,
        incidents_repository:,
        github_client:
    )
      @chat_client = chat_client
      @github_client = github_client
      @incidents_repository = incidents_repository
    end

    def execute
      chat_client.say(message: BACK_TO_GREEN_MESSAGE)
      chat_client.set_channel_topic(message: ENV['SUCCESS_CHANNEL_TOPIC'] || DEFAULT_CHANNEL_TOPIC)

      incident = incidents_repository.find_last_unresolved

      github_client.open_pull_requests.each do |pull_request|
        github_client.set_status_for_commit(
          commit_sha: pull_request.head_sha,
          status: Core::Github::Status.success
        )
      end

      if incident
        incident.resolved_at = Time.now

        incidents_repository.save(incident)
      end
    end
  end
end
