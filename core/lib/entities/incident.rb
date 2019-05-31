require_relative './keyword_struct'

INCIDENT_FIELDS = %i[id created_at resolved_at].freeze

Incident = KeywordStruct.new(*INCIDENT_FIELDS)
