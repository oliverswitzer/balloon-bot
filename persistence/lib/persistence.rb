module Persistence
  require 'active_record'
  require 'persistence/incidents_repository'
  require 'persistence/messages_repository'
  require 'persistence/incident_record'
  require 'persistence/message_record'

  if defined? Rails
    require "active_record/railtie"

    class Engine < Rails::Engine
      initializer :add_migrations do |app|
        app.config.paths["db/migrate"] << File.join(__dir__, "migrations")
      end
    end
  end

  INCIDENTS_REPOSITORY = Persistence::IncidentsRepository.new
  MESSAGES_REPOSITORY = Persistence::MessagesRepository.new
end
