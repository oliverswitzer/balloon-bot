require 'sinatra/base'

module SlackMathbot
  class Web < Sinatra::Base
    get '/' do
      'Balloon bot is a-runnin'
    end
  end
end
