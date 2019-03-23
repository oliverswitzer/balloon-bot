module Persistence
  require 'incidents_repository'
  require 'messages_repository'

  INCIDENTS_REPOSITORY = IncidentsRepository.new
  MESSAGES_REPOSITORY = MessagesRepository.new
end