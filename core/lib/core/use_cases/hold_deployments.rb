module Core
  class HoldDeployments
    attr_reader :chat_client, :incidents_repository, :github_client, :messages_repository

    ERROR_MESSAGES = {
      already_holding: 'I\'m already holding deployments'
    }.freeze
    MESSAGE = 'please hold deploys and merges! Setting failing github statuses on all pull requests'.freeze
    DEFAULT_CHANNEL_TOPIC = '⚠️ Hold deploys ⚠️'.freeze

    def initialize(
      chat_client:,
        incidents_repository:,
        messages_repository:,
        github_client:
    )
      @chat_client = chat_client
      @incidents_repository = incidents_repository
      @messages_repository = messages_repository
      @github_client = github_client
    end

    def execute(incoming_message)
      if incidents_repository.find_last_unresolved
        chat_client.say(message: ERROR_MESSAGES[:already_holding])
        return
      end

      chat_client.say(message: "#{slack_handle} #{MESSAGE}")
      chat_client.say(message: "#{ENV['ADDITIONAL_FAILURE_MESSAGE']}") unless ENV['ADDITIONAL_FAILURE_MESSAGE'].nil?
      chat_client.set_channel_topic(message: ENV['FAILURE_CHANNEL_TOPIC'] || DEFAULT_CHANNEL_TOPIC)

      incident = incidents_repository.save(Core::Incident.new)
      messages_repository.save(
        Core::Message.new(
          incident: incident,
          **incoming_message.attributes
        )
      )

      github_client.open_pull_requests.each do |pull_request|
        github_client.set_status_for_commit(
          commit_sha: pull_request.head_sha,
          status: Core::Github::Status.failure,
          more_info_url: chat_client.url_for_message(
            timestamp: incoming_message.timestamp,
            channel_id: incoming_message.channel_id
          )
        )
      end
    end

    private def slack_handle
      ENV['SLACK_HANDLE_TO_NOTIFY'] || '<!channel|channel>'
    end
  end
end
