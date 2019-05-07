require 'types'

class PullRequestEvent < Dry::Struct
  OPENED = 'opened'.freeze
  REOPENED = 'reopened'.freeze
  SYNCHRONIZE = 'synchronize'.freeze

  attribute :type, Types::Strict::String
  attribute :pull_request, Types.Instance(PullRequest)
end
