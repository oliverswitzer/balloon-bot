require './types'

class SlackMessage < Dry::Struct
  attribute :timestamp, Types::Strict::String
  attribute :channel_id, Types::Strict::String
end