require 'test_support'

require 'persistence'
require 'core'

ActiveRecord::Base.establish_connection("postgresql://localhost:5432/balloon_bot_test")

migrations_path = File.join(__dir__, "..", "lib", "migrations")
ActiveRecord::MigrationContext.new(migrations_path).migrate

RSpec.configure do |c|
  c.before do
    IncidentRecord.destroy_all
    MessageRecord.destroy_all
  end
end
