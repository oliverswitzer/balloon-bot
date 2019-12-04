require 'core/spec/entity_factory'

def messages_repository_contract(repo_class:, incident_repo_class:)
  describe "MessagesRepository contract for: #{repo_class.name}" do
    subject { repo_class.new }
    let(:incidents_repository) { incident_repo_class.new }

    describe '#save' do
      context 'when message id has not already been set' do
        it 'should generate unique integer ids for each persisted message' do
          incident = incidents_repository.save(Core::EntityFactory.build_incident)

          message1 = Core::EntityFactory.build_message(incident: incident)
          message2 = Core::EntityFactory.build_message(incident: incident)

          persisted_message1 = subject.save(message1)
          persisted_message2 = subject.save(message2)

          expect(persisted_message1.id).to be_a(Integer)
          expect(persisted_message2.id).to be_a(Integer)
          expect(persisted_message1.id).not_to eq(persisted_message2.id)
        end

        it 'correctly persists all the messages attributes' do
          incident = incidents_repository.save(Core::EntityFactory.build_incident)

          message = Core::EntityFactory.build_message(
            incident: incident,
            text: 'some updated message',
            author_id: '123abc456',
            channel_id: '456def789'
          )

          subject.save(message)

          saved_message = subject.find(message.id)

          expect(saved_message.id).to eq(message.id)
          expect(saved_message.text).to eq('some updated message')
          expect(saved_message.author_id).to eq('123abc456')
          expect(saved_message.channel_id).to eq('456def789')
        end
      end

      context 'when id has been set' do
        it 'updates the existing message with the corresponding id' do
          incident = incidents_repository.save(Core::EntityFactory.build_incident)

          persisted_message = subject.save(Core::EntityFactory.build_message(incident: incident))

          subject.save(
            Core::EntityFactory.build_message(
              incident: incident,
              id: persisted_message.id,
              text: 'some updated message',
              author_id: '123abc456',
              channel_id: '456def789'
            )
          )

          updated_message = subject.find(persisted_message.id)

          expect(updated_message.id).to eq(persisted_message.id)
          expect(updated_message.text).to eq('some updated message')
          expect(updated_message.author_id).to eq('123abc456')
          expect(updated_message.channel_id).to eq('456def789')
        end
      end

      context 'when associated incident does not have an id' do
        it 'should raise an error' do
          expect { subject.save(Core::EntityFactory.build_message) }.to raise_error(
            RuntimeError,
            'Message must have an associated persisted incident'
          )
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

        found_messages = subject.find_by_incident_id(incident1.id)
        expect(found_messages.map(&:id)).to contain_exactly(
          message_1_for_incident.id,
          message_2_for_incident.id
        )
      end
    end

    describe '#find_by_timestamp' do
      it 'returns the message that matches the given timestamp' do
        incident = incidents_repository.save(Core::EntityFactory.build_incident)

        message1 = Core::EntityFactory.build_message(incident: incident, timestamp: '123')
        message2 = Core::EntityFactory.build_message(incident: incident, timestamp: '456')

        subject.save(message1)
        subject.save(message2)

        found_message = subject.find_by_timestamp('123')

        expect(found_message.id).to eq(message1.id)
      end

      it 'returns nil if the message is not found' do
        found_message = subject.find_by_timestamp('123')

        expect(found_message).to be_nil
      end
    end
  end
end
