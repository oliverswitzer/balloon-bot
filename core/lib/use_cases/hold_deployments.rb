class HoldDeployments
  attr_reader :chat_client, :incidents_repository, :github_client, :messages_repository

  ERROR_MESSAGES = {
    already_holding: 'I\'m already holding deployments'
  }.freeze
  MESSAGE = 'Holding deploys! Setting failing github statuses on all open and future pull requests'.freeze
  CHANNEL_TOPIC = '⚠️ Hold deploys ⚠️'.freeze

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

  def execute(request)
    puts "IM HOLDING DEPLOYS"

    if incidents_repository.find_last_unresolved
      chat_client.say(message: ERROR_MESSAGES[:already_holding])
      return
    end

    chat_client.say(message: MESSAGE)
    chat_client.set_channel_topic(message: CHANNEL_TOPIC)

    incident = incidents_repository.save(Incident.new)
    messages_repository.save(
      Message.new(
        incident: incident,
        text: request.message[:text],
        timestamp: request.message[:timestamp],
        channel_id: request.message[:channel_id]
      )
    )

    github_client.open_pull_requests.each do |pull_request|
      github_client.set_status_for_commit(
        commit_sha: pull_request.head_sha,
        status: Github::Status.failure,
        more_info_url: chat_client.url_for_message(
          timestamp: request.message[:timestamp],
          channel_id: request.message[:channel_id]
        )
      )
    end
  end


  class Request < Dry::Struct
    attribute :message, Types::Hash.schema(
      text: Types::Strict::String,
      timestamp: Types::Strict::String,
      channel_id: Types::Strict::String
    )
  end
end
