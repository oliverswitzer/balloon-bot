require './core/entities/types'

class Message < Dry::Struct::Value
  attribute :id, Types::Strict::Integer.meta(omittable: true)
  attribute :text, Types::Strict::String
end