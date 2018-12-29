require './core/entities/types'
require './core/entities/incident'

class Message < Dry::Struct::Value
  attribute :id, Types::Strict::Integer.meta(omittable: true)
  attribute :incident, Types::Instance(Incident).optional.meta(omittable: true)
  attribute :text, Types::Strict::String
end