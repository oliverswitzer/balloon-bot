module Persistence
  require 'active_record'
  require 'incidents_repository'
  require 'messages_repository'
  require 'incident_record'
  require 'message_record'

  if defined? Rails
    require "active_record/railtie"

    class Engine < Rails::Engine
      initializer :add_migrations do |app|
        app.config.paths["db/migrate"] << File.join(__dir__, "migrations")
      end
    end
  end

  INCIDENTS_REPOSITORY = IncidentsRepository.new
  MESSAGES_REPOSITORY = MessagesRepository.new
end
