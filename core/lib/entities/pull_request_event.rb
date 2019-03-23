require 'types'

class PullRequestEvent < Dry::Struct
  OPENED = 'opened'
  REOPENED = 'reopened'

  attribute :type, Types::Strict::String
  attribute :pull_request, Types.Instance(PullRequest)
end
