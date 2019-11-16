module Core
  require 'types'
  require 'core/entities/incident'
  require 'core/entities/message'
  require 'core/entities/incident_with_messages'
  require 'core/entities/github/pull_request'
  require 'core/entities/github/pull_request_event'
  require 'core/entities/github/status'

  require 'core/use_cases/continue_deployments'
  require 'core/use_cases/hold_deployments'
  require 'core/use_cases/record_message_for_incident'
  require 'core/use_cases/incident_analysis/calculate_total_incident_duration'
  require 'core/use_cases/incident_analysis/calculate_incident_duration_over_time'
  require 'core/use_cases/update_new_pull_request_status'
  require 'core/use_cases/incident_analysis/fetch_incidents'

  require 'core/contracts/messages_repository_contract'
  require 'core/contracts/incidents_repository_contract'

  require 'core/services/incident_analysis/message_presenter'
  require 'core/services/incident_analysis/incident_terms_analyzer'
  require 'core/services/incident_analysis/text_cleaner'
end
