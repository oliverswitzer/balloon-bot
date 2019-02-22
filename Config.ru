$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
require 'rufus-scheduler'

require './clients/web'
require './app'

Dotenv.load! unless ENV['ENVIRONMENT'] == 'production'

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

# Heroku will shut down the server if your app doesn't bind to it's available port within 60 seconds.
# Running this dumb web server is necessary to prevent this from happening.
run SlackMathbot::Web
