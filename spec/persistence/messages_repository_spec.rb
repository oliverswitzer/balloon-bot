require 'rspec'
require './spec/core/test-support/entity_factory'

require './persistence/messages_repository'
require './persistence/incidents_repository'

require './core/entities/message'
require './core/entities/incident'

describe MessagesRepository do
  let(:incidents_repository) { IncidentsRepository.new }

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

  describe '#find_by_incident_id' do
    it 'only returns messages belonging to the passed in incident id' do
      incident1 = EntityFactory.build_incident
      incident2 = EntityFactory.build_incident

      incidents_repository.save(incident1)
      incidents_repository.save(incident2)

      message_1_for_incident = EntityFactory.build_message(incident: incident1)
      message_2_for_incident = EntityFactory.build_message(incident: incident1)
      message_for_other_incident = EntityFactory.build_message(incident: incident2)

      subject.save(message_1_for_incident)
      subject.save(message_2_for_incident)
      subject.save(message_for_other_incident)

      expect(subject.find_by_incident_id(incident1.id)).to contain_exactly(
        message_1_for_incident,
        message_2_for_incident
      )
    end
  end
end