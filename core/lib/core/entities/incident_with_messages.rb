INCIDENT_WITH_MESSAGES_FIELDS = ([:messages].unshift(*INCIDENT_FIELDS)).freeze

module Core
  IncidentWithMessages = Core::KeywordStruct.new(*INCIDENT_WITH_MESSAGES_FIELDS)
end
