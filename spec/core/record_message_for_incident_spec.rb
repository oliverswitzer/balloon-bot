require 'rspec'
require './core/record_message_for_incident'
require './persistence/messages_repository'
require './slack_client_wrapper'

describe RecordMessageForIncident do
  let(:slack_client_wrapper_spy) { spy(SlackClientWrapper) }
  let(:messages_repository_spy) { spy(MessagesRepository) }

  subject do
    RecordMessageForIncident.new(
      chat_client: slack_client_wrapper_spy,
      messages_repository: messages_repository_spy
    )
  end

  describe '#execute' do
    context 'when message is sent in configured deployments channel' do
      it 'persists the message' do
        subject.execute(text: 'foo', channel: ENV['DEPLOYMENTS_CHANNEL'])

        expect(messages_repository_spy).to have_received(:save) do |message|
          expect(message.text).to eq('foo')
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