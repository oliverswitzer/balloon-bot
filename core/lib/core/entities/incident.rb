require_relative './keyword_struct'

INCIDENT_FIELDS = %i[id created_at resolved_at].freeze

module Core
  Incident = Core::KeywordStruct.new(*INCIDENT_FIELDS)
end