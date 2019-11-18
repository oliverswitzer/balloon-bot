require 'rspec'
require 'pry'
require 'dotenv'
require 'active_support/testing/time_helpers'

RSpec.configure do |config|
  config.before(:each) do
    test_dotenv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../web/.env.test'))

    Dotenv.load(test_dotenv_path)
  end

  config.include ActiveSupport::Testing::TimeHelpers
end
