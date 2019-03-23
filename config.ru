$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'

require './app'
require 'pry'

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


require 'sinatra/base'
class Server < Sinatra::Base
  get '/' do
    # Heroku will shut down the server if your app doesn't bind to it's available port within 60 seconds.
    # Running this dumb web server is necessary to prevent this from happening

    'Balloon bot is a-runnin'
  end

  post '/pull-request' do
    request.body.rewind
    request_body = JSON.parse(request.body.read)

    event = PullRequestEvent.new(
      type: request_body['action'],
      pull_request: PullRequest.new(
        head_sha: request_body['pull_request']['head']['sha'],
        branch: request_body['pull_request']['head']['ref']
      )
    )

    UpdateNewPullRequestStatus.new(
      github_client: GithubClientWrapper.new,
      incidents_repository: Persistence::INCIDENTS_REPOSITORY,
      messages_repository: Persistence::MESSAGES_REPOSITORY,
      chat_client: SlackClientWrapper.new(App.slack_bot_client)
    ).execute(github_event: event)
  end
end

run Server
