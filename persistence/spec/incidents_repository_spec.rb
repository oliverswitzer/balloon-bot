require_relative './spec_helper'

incidents_repository_contract(
  IncidentsRepository
)

# Implementation specific behavior tested below
describe IncidentsRepository do
  let(:messages_repository) { MessagesRepository.new }

  describe '#find_last_n_with_messages' do
    it 'return last n incidents with their associated messages' do
      incident1 = subject.save(EntityFactory.build_incident)
      messages_repository.save(EntityFactory.build_message(incident: incident1))
      messages_repository.save(EntityFactory.build_message(incident: incident1))

      incident2 = subject.save(EntityFactory.build_incident)
      messages_repository.save(EntityFactory.build_message(incident: incident2))
      messages_repository.save(EntityFactory.build_message(incident: incident2))
      messages_repository.save(EntityFactory.build_message(incident: incident2))

      found_incidents = subject.find_last_n_with_messages(2)

      expect(found_incidents.first.messages.count).to eq(2)
      expect(found_incidents.last.messages.count).to eq(3)
    end
  end
end
