require './core/entities/types'
require 'dry/struct/with_setters'

class Incident < Dry::Struct::Value
  include Dry::Struct::Setters

  attribute :id, Types::Strict::Integer.meta(omittable: true)
  attribute :created_at, Types::Strict::Time.meta(omittable: true)
  attribute :resolved_at, Types::Strict::Time.optional.meta(omittable: true)
end