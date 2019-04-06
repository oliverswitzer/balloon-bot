require 'test_support'

require 'persistence'
require 'core'

ActiveRecord::Base.establish_connection("postgresql://localhost:5432/balloon_bot_test")

migrations_path = File.join(__dir__, "..", "lib", "migrations")
ActiveRecord::Migrator.up(migrations_path)

RSpec.configure do |c|
  c.before do
    IncidentRecord.destroy_all
    MessageRecord.destroy_all
  end
end
