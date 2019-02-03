require 'octokit'
require 'pry'
require './core/entities/pull_request'

class GithubClientWrapper
  FAILURE_STATE = 'failure'

  attr_reader :github_client

  def initialize(github_client: Octokit::Client.new(access_token: ENV['GITHUB_PERSONAL_ACCESS_TOKEN']))
    @github_client = github_client
  end

  def open_pull_requests
    github_client.pull_requests(ENV['GITHUB_REPO'], { state: :open }).map do |pr|
      PullRequest.new(head_sha: pr[:head][:sha])
    end
  end

  def set_status_for_commit(commit_sha:, state:, context:, description:, more_info_url:)
    github_client.create_status(
      ENV['GITHUB_REPO'],
      commit_sha,
      state,
      context: context,
      description: description,
      target_url: more_info_url
    )
  end
end
