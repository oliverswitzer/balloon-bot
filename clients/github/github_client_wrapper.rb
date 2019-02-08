require 'octokit'
require 'pry'
require './clients/github/pull_request'

class GithubClientWrapper
  STATUS_FAILURE_STATE = 'failure'.freeze
  STATUS_TEXT = {
    failure: {
      context: 'BalloonBot: Master is currently broken'.freeze,
      description: 'Please wait to merge your changes'.freeze
    }
  }.freeze

  attr_reader :github_client

  def initialize(github_client: Octokit::Client.new(access_token: ENV['GITHUB_PERSONAL_ACCESS_TOKEN']))
    @github_client = github_client
  end

  def open_pull_requests
    github_client.pull_requests(ENV['GITHUB_REPO'], { state: :open }).map do |pr|
      PullRequest.new(
        head_sha: pr[:head][:sha],
        branch: pr[:head][:ref]
      )
    end
  end

  def set_status_for_commit(commit_sha:, status:, more_info_url: nil)
    github_client.create_status(
      ENV['GITHUB_REPO'],
      commit_sha,
      status.state,
      context: status.context,
      description: status.description,
      target_url: more_info_url || ''
    )
  end
end
