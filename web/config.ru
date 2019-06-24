# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'dotenv'
require 'bundler'

Bundler.require
puts "***********************"
puts "***********************"
puts "***********************"
puts "***********************"
puts "LOAD PATH:"
puts $LOAD_PATH.inspect
puts "***********************"
puts "***********************"
puts "***********************"
puts "***********************"
puts "***********************"
puts "LOADED_FEATURES:"
puts $LOADED_FEATURES.inspect
puts "***********************"
puts "***********************"
puts "***********************"
puts "***********************"
puts "***********************"

Dotenv.load! if ENV['RAILS_ENV'] == 'development'

class App
  def self.run
    Clients::Slack::BalloonBot.instance.on(:message, Hooks::Message.new)
    Clients::Slack::BalloonBot.run
  end

  def self.slack_bot_client
    Clients::Slack::BalloonBot.instance.send(:client)
  end
end

Thread.abort_on_exception = true
Thread.new do
  begin
    App.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Rails.application
