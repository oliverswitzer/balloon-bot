require 'sinatra/base'

require './clients/github/pull_request_event'
require './clients/github/pull_request'
require './clients/slack/slack_client_wrapper'
require './core/update_new_pull_request_status'
require './persistence/persistence'

module Clients
  class Web < Sinatra::Base
    get '/' do
      'Balloon bot is a-runnin'
    end

    post '/pull-request' do
      request.body.rewind
      request_body = JSON.parse(request.body.read)

      event = PullRequestEvent.new(
        type: request_body['action'],
        pull_request: PullRequest.new(
          head_sha: request_body['pull_request']['head']['sha'],
          branch: request_body['pull_request']['head']['ref']
        )
      )

      UpdateNewPullRequestStatus.new(
        incidents_repository: Persistence::INCIDENTS_REPOSITORY,
        messages_repository: Persistence::MESSAGES_REPOSITORY,
        chat_client: SlackClientWrapper.new(App.slack_bot_client)
      ).execute(github_event: event)
    end
  end
end
