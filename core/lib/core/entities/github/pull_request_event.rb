require 'types'

module Core
  module Github
    class PullRequestEvent < Dry::Struct
      OPENED = 'opened'.freeze
      REOPENED = 'reopened'.freeze
      SYNCHRONIZE = 'synchronize'.freeze

      attribute :type, Types::Strict::String
      attribute :pull_request, Types.Instance(Core::Github::PullRequest)
    end
  end
end

