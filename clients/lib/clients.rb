module Clients
  require 'dotenv'
  require 'slack-ruby-bot'
  require 'slack-ruby-client'

  require 'core'
  require 'persistence'

  require 'clients/slack'
  require 'clients/types'
  require 'clients/github/wrapper'

  Dotenv.load! if ENV['RAILS_ENV'] == 'development'

  SLACK_CLIENT_WRAPPER = Slack::Wrapper.new(
    ::Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  )

  HOLD_DEPLOYMENTS = ::Core::HoldDeployments.new(
    chat_client: SLACK_CLIENT_WRAPPER,
    incidents_repository: ::Persistence::INCIDENTS_REPOSITORY,
    messages_repository: ::Persistence::MESSAGES_REPOSITORY,
    github_client: Github::Wrapper.new
  )

  CONTINUE_DEPLOYMENTS = ::Core::ContinueDeployments.new(
    chat_client: SLACK_CLIENT_WRAPPER,
    incidents_repository: ::Persistence::INCIDENTS_REPOSITORY,
    github_client: Github::Wrapper.new
  )

  RECORD_MESSAGE_FOR_INCIDENT = ::Core::RecordMessageForIncident.new(
    chat_client: SLACK_CLIENT_WRAPPER,
    incidents_repository: ::Persistence::INCIDENTS_REPOSITORY,
    messages_repository: ::Persistence::MESSAGES_REPOSITORY
  )
end
