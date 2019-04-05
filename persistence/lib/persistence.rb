module Persistence
  require 'active_record'
  require 'ar_incidents_repository'
  require 'ar_messages_repository'
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

  INCIDENTS_REPOSITORY = ArIncidentsRepository.new
  MESSAGES_REPOSITORY = ArMessagesRepository.new
end
