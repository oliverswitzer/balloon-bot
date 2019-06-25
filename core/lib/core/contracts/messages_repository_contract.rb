require 'core/spec/entity_factory'

def messages_repository_contract(repo_class:, incident_repo_class:)
  describe "MessagesRepository contract for: #{repo_class.name}" do
    subject { repo_class.new }
    let(:incidents_repository) { incident_repo_class.new }

    describe '#save' do
      context 'when message id has not already been set' do
        it 'should generate unique integer ids for each persisted message' do
          message1 = Core::EntityFactory.build_message
          message2 = Core::EntityFactory.build_message

          persisted_message1 = subject.save(message1)
          persisted_message2 = subject.save(message2)

          expect(persisted_message1.id).to be_a(Integer)
          expect(persisted_message2.id).to be_a(Integer)
          expect(persisted_message1.id).not_to eq(persisted_message2.id)
        end
      end

      context 'when id has been set' do
        it 'updates the existing message with the corresponding id' do
          persisted_message = subject.save(Core::EntityFactory.build_message)

          updated_message = subject.save(
            Core::EntityFactory.build_message(
              id: persisted_message.id,
              text: 'some updated message'
            )
          )

          expect(updated_message.id).to eq(persisted_message.id)
          expect(updated_message.text).to eq('some updated message')
        end
      end

      context 'when associated incident does not have an id' do
        it 'should raise an error' do
          # TODO: Implement! Was on a plane and couldn't look up docs on how to assert that a method call raises
        end
      end
    end

    describe '#find_by_incident_id' do
      it 'only returns messages belonging to the passed in incident id' do
        incident1 = Core::EntityFactory.build_incident
        incident2 = Core::EntityFactory.build_incident

        incidents_repository.save(incident1)
        incidents_repository.save(incident2)

        message_1_for_incident = Core::EntityFactory.build_message(incident: incident1)
        message_2_for_incident = Core::EntityFactory.build_message(incident: incident1)
        message_for_other_incident = Core::EntityFactory.build_message(incident: incident2)

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
end
