require 'test_support'

require 'persistence'
require 'core'

# Code below is supposed to run migrations before tests get run. However, I am getting
# and error because I think we are installing the wrong version of ActiveRecord (one
# where the method `up` no longer exists on ActiveRecord::Migrator)
#
# Need to figure out how to lock in the ActiveRecord version specified in the Gemfile.lock
# of this gem (Robert said that this was possible)
#
# ActiveRecord::Base.establish_connection("postgresql://localhost:5432/balloon_bot_test")
# migrations_path = File.join(__dir__, "..", "lib", "migrations")
# ActiveRecord::Migrator.up(migrations_path)

RSpec.configure do |c|
  c.before do
    Persistence::IncidentRecord.destroy_all
    Persistence::MessageRecord.destroy_all
  end
end
