require 'sinatra/base'

module Clients
  class Web < Sinatra::Base
    get '/' do
      'Balloon bot is a-runnin'
    end
  end
end
