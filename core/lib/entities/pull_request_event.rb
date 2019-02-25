require 'types'

class PullRequestEvent < Dry::Struct
  OPENED = 'opened'

  attribute :type, Types::Strict::String
  attribute :pull_request, Types.Instance(PullRequest)
end
