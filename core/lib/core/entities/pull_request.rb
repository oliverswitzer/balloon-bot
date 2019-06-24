require 'types'

module Core
  class PullRequest < Dry::Struct
    attribute :head_sha, Types::Strict::String
    attribute :branch, Types::Strict::String
  end
end
