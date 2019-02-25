require 'rspec'
require 'dotenv'
require 'clients'

RSpec.configure do |c|
  c.before(:each) do
    Dotenv.load('../.env.test')
  end
end