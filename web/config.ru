# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'clients'
require 'dotenv'

Dotenv.load! if ENV['RAILS_ENV'] == 'development'

class App
  def self.run
    BalloonBot.instance.on(:message, Hooks::Message.new)
    BalloonBot.run
  end

  def self.slack_bot_client
    BalloonBot.instance.send(:client)
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
