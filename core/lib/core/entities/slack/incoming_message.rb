module Core
  module Slack
    class IncomingMessage < Dry::Struct
      attribute :text, Types::Strict::String
      attribute :channel_id, Types::Strict::String
      attribute :author_id, Types::Strict::String
      attribute :timestamp, Types::Strict::String

      PRIVATE_MESSAGE_ID_REGEX = /(D[A-Z0-9]{8}|G[A-Z0-9]{8})/

      def is_private?
        PRIVATE_MESSAGE_ID_REGEX.match? channel_id
      end
    end
  end
end