require './core/entities/types'

class Incident < Dry::Struct::Value
  attribute :id, Types::Strict::Integer.meta(omittable: true)
  attribute :created_at, Types::Strict::Time.meta(omittable: true)
  attribute :resolved_at, Types::Strict::Time.optional.meta(omittable: true)
end