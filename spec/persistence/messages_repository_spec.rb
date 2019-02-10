require 'rspec'
require './spec/core/test-support/entity_factory'

require './persistence/messages_repository'
require './core/entities/message'
require './core/entities/incident'

describe MessagesRepository do
  describe '#save' do
    it 'should generate unique integer ids for each persisted message' do
      message1 = EntityFactory.build_message
      message2 = EntityFactory.build_message

      persisted_message1 = subject.save(message1)
      persisted_message2 = subject.save(message2)

      expect(persisted_message1.id).to be_a(Integer)
      expect(persisted_message2.id).to be_a(Integer)
      expect(persisted_message1.id).not_to eq(persisted_message2.id)
    end
  end
end