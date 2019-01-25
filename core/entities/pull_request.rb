class PullRequest
  attr_reader :head_sha

  def initialize(head_sha:)
    @head_sha = head_sha
  end
end
