require_relative './incident_behavior'

module Core
  INCIDENT_WITH_MESSAGES_FIELDS = ([:messages].unshift(*Core::INCIDENT_FIELDS)).freeze

  IncidentWithMessages = Core::KeywordStruct.new(*INCIDENT_WITH_MESSAGES_FIELDS) do
    include IncidentBehavior
  end
end
