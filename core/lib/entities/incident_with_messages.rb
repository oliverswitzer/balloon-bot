INCIDENT_WITH_MESSAGES_FIELDS = ([:messages].concat(INCIDENT_FIELDS)).freeze

IncidentWithMessages = KeywordStruct.new(*INCIDENT_WITH_MESSAGES_FIELDS)
