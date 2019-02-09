require './clients/github/github_client_wrapper'
require './clients/github/status'
require 'pry'

class UpdatePullRequestStatuses
  attr_reader :github_client, :incidents_repository

  def initialize(
    github_client: GithubClientWrapper.new,
    incidents_repository:
  )
    @github_client = github_client
    @incidents_repository = incidents_repository
  end

  def execute
    if active_incident?
      puts "Ongoing incident: marking all open pull requests as failing"
      mark_open_pull_requests_as_failing
    end
  end

  private def active_incident?
    incidents_repository.find_last_unresolved != nil
  end

  private def mark_open_pull_requests_as_failing
    github_client.open_pull_requests.each do |pull_request|
      puts "Marking PR for branch #{pull_request.branch} as failing"
      github_client.set_status_for_commit(
        commit_sha: pull_request.head_sha,
        status: Github::Status.failure
      )
    end
  end
end
