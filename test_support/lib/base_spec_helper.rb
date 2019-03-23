require 'rspec'
require 'pry'
require 'dotenv'

RSpec.configure do |c|
  c.before(:each) do
    Dotenv.load('.env.test')
  end
end