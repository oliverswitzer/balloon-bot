require_relative '../../../spec_helper'

describe Core::IncidentAnalysis::FetchMessagesForIncident do
  let(:messages_repository) { FakeMessagesRepository.new }
  let(:incidents_repository) { FakeIncidentsRepository.new }
  let(:slack_client_spy) { spy('Clients::Slack::Wrapper') }

  subject do
    Core::IncidentAnalysis::FetchMessagesForIncident.new(
      messages_repository: messages_repository,
      chat_client: slack_client_spy
    )
  end

  describe '#execute' do
    context 'when there are 3 messages for the passed in incident id' do
      let(:incident) do
        incidents_repository.save(Core::EntityFactory.build_incident)
      end

      before do
        messages_repository.save(Core::EntityFactory.build_message(channel_id: '123', incident: incident))
        messages_repository.save(Core::EntityFactory.build_message(channel_id: '456', incident: incident))
        messages_repository.save(Core::EntityFactory.build_message(channel_id: '789', incident: incident))

        allow(slack_client_spy).to receive(:channel_name).with('123').and_return('channel 1')
        allow(slack_client_spy).to receive(:channel_name).with('456').and_return('channel 2')
        allow(slack_client_spy).to receive(:channel_name).with('789').and_return('channel 3')
      end

      it 'should return all three messages with their channel name fetched from slack' do
        messages = subject.execute(incident_id: incident.id)

        expect(messages.map(&:channel_name)).to contain_exactly('channel 1', 'channel 2', 'channel 3')
      end
    end
  end
end