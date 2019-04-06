require 'rspec'
require 'pry'
require 'dotenv'

RSpec.configure do |c|
  c.before(:each) do
    test_dotenv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../web/.env.test'))

    Dotenv.load(test_dotenv_path)
  end
end
