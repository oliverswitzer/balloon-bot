class GithubHooksController < ApplicationController
  def pull_request
    request_body = JSON.parse(request.body.read)

    event = Core::Github::PullRequestEvent.new(
      type: request_body['action'],
      pull_request: Core::Github::PullRequest.new(
        head_sha: request_body['pull_request']['head']['sha'],
        branch: request_body['pull_request']['head']['ref']
      )
    )

    Core::UpdateNewPullRequestStatus.new(
      github_client: Clients::GITHUB_CLIENT_WRAPPER,
      incidents_repository: Persistence::INCIDENTS_REPOSITORY,
      messages_repository: Persistence::MESSAGES_REPOSITORY,
      chat_client: Clients::SLACK_CLIENT_WRAPPER
    ).execute(github_event: event)
  end
end
