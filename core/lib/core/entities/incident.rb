require_relative './keyword_struct'
require_relative './incident_behavior'

INCIDENT_FIELDS = %i[id created_at resolved_at].freeze

module Core
  Incident = Core::KeywordStruct.new(*INCIDENT_FIELDS) do
    include Core::IncidentBehavior
  end
end
