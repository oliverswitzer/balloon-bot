require_relative '../../spec_helper'

describe Core::RecordMessageForIncident do
  let(:slack_client_wrapper_spy) { spy('Clients::Slack::Wrapper') }
  let(:messages_repository_spy) { spy(FakeMessagesRepository) }
  let(:incidents_repository) { FakeIncidentsRepository.new }

  subject do
    Core::RecordMessageForIncident.new(
      chat_client: slack_client_wrapper_spy,
      messages_repository: messages_repository_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
    let(:incoming_message) do
      Core::EntityFactory.build_incoming_slack_message(
        text: 'some message',
        timestamp: '456',
        channel_id: '123abc',
        author_id: '456def'
      )
    end

    context 'when there is an unresolved incident' do
      let!(:persisted_incident) do
        incidents_repository.save(Core::Incident.new(resolved_at: nil))
      end

      context 'when message is sent in configured deployments channel' do
        before do
          ENV['DEPLOYMENTS_CHANNEL'] = 'some channel'

          expect(slack_client_wrapper_spy).to receive(:channel_name)
            .with('123abc')
            .and_return('some channel')
        end

        it 'persists the message with the unresolved incident id' do
          subject.execute(incoming_message)

          expect(messages_repository_spy).to have_received(:save) do |message|
            expect(message.text).to eq('some message')
            expect(message.timestamp).to eq('456')
            expect(message.channel_id).to eq('123abc')
            expect(message.author_id).to eq('456def')
            expect(message.incident).to eq(persisted_incident)
          end
        end
      end

      context 'when message is sent in configured incident response channel' do
        before do
          ENV['INCIDENT_RESPONSE_CHANNEL'] = 'some incident channel'

          expect(slack_client_wrapper_spy).to receive(:channel_name)
            .with('123abc')
            .and_return('some incident channel')
        end

        it 'persists the message with the unresolved incident id' do
          subject.execute(incoming_message)

          expect(messages_repository_spy).to have_received(:save) do |message|
            expect(message.text).to eq('some message')
            expect(message.timestamp).to eq('456')
            expect(message.channel_id).to eq('123abc')
            expect(message.incident).to eq(persisted_incident)
          end
        end
      end

      context 'when message is sent in a channel other than the configured deployments channel' do
        before do
          expect(slack_client_wrapper_spy).to receive(:channel_name)
            .with('123abc')
            .and_return('some other channel')
        end

        it 'does not persist the message' do
          subject.execute(incoming_message)

          expect(messages_repository_spy).not_to have_received(:save)
        end
      end
    end

    context 'when there is NOT an unresolved incident' do
      it 'does not persist the message' do
        subject.execute(incoming_message)

        expect(messages_repository_spy).not_to have_received(:save)
      end
    end
  end
end
