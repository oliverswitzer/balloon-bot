class PullRequest
  attr_reader :head_sha, :branch

  def initialize(head_sha:, branch:)
    @head_sha = head_sha
    @branch = branch
  end
end
