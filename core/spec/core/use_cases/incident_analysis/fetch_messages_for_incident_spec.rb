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
        messages = [
          messages_repository.save(Core::EntityFactory.build_message(incident: incident)),
          messages_repository.save(Core::EntityFactory.build_message(incident: incident)),
          messages_repository.save(Core::EntityFactory.build_message(incident: incident))
        ]

        messages.each.with_index do |message, i|
          allow(slack_client_spy).to receive(:channel_name).with(message.channel_id).and_return("channel #{i + 1}")
        end

        messages.each.with_index do |message, i|
          allow(slack_client_spy).to receive(:handle_name).with(message.author_id).and_return("some handle #{i + 1}")
        end
      end

      it 'should return all three messages with their channel name and author handle fetched from slack' do
        messages = subject.execute(incident_id: incident.id)

        expect(messages.map(&:channel_name)).to contain_exactly('channel 1', 'channel 2', 'channel 3')
        expect(messages.map(&:slack_handle)).to contain_exactly('some handle 1', 'some handle 2', 'some handle 3')
      end
    end
  end
end