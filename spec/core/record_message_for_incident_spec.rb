require 'rspec'
require './core/record_message_for_incident'
require './core/entities/incident'
require './persistence/messages_repository'
require './persistence/incidents_repository'
require './clients/slack/slack_client_wrapper'

describe RecordMessageForIncident do
  let(:slack_client_wrapper_spy) { spy(SlackClientWrapper) }
  let(:messages_repository_spy) { spy(MessagesRepository) }
  let(:incidents_repository) { IncidentsRepository.new }

  subject do
    RecordMessageForIncident.new(
      chat_client: slack_client_wrapper_spy,
      messages_repository: messages_repository_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
    context 'when message is sent in configured deployments channel' do
      let(:channel) { ENV['DEPLOYMENTS_CHANNEL'] }

      context 'when there is an unresolved incident' do
        let!(:persisted_incident) do
          incidents_repository.save(Incident.new(resolved_at: nil))
        end

        it 'persists the message with the unresolved incident id' do
          subject.execute(text: 'foo', channel: channel)

          expect(messages_repository_spy).to have_received(:save) do |message|
            expect(message.text).to eq('foo')
            expect(message.incident).to eq(persisted_incident)
          end
        end
      end

      context 'when there is NOT an unresolved incident' do
        it 'does not persist the message' do
          subject.execute(text: 'foo', channel: channel)

          expect(messages_repository_spy).not_to have_received(:save)
        end
      end
    end

    context 'when message is sent in a channel other than the configured deployments channel' do
      it 'does not persist the message' do
        subject.execute(text: 'foo', channel: 'some-other-channel')

        expect(messages_repository_spy).not_to have_received(:save)
      end
    end
  end
end