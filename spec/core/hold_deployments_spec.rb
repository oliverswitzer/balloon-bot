require 'rspec'
require './core/hold_deployments'
require './slack_client_wrapper'
require './persistence/incidents_repository'


describe HoldDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  let(:incidents_repository_spy) { spy(IncidentsRepository) }

  subject do
    HoldDeployments.new(
      chat_client: slack_client_spy,
      incidents_repository: incidents_repository_spy
    )
  end

  describe '#execute' do
    context 'when there is already an unresolved incident' do
      before do
        expect(incidents_repository_spy).to receive(:find_last_unresolved)
          .and_return(Incident.new(resolved_at: nil))
      end

      it 'warns that deployments are already being held' do
        subject.execute

        expect(slack_client_spy).to have_received(:say)
          .with(message: SlackClientWrapper::ERROR_MESSAGES[:already_holding])
      end
    end

    it 'tells the specified deployments channel to hold deploys' do
      subject.execute

      expect(slack_client_spy).to have_received(:say)
        .with(message: SlackClientWrapper::FAILURE_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute

      expect(slack_client_spy).to have_received(:set_channel_topic)
        .with(message: SlackClientWrapper::FAILURE_CHANNEL_TOPIC)
    end

    it 'creates an incident' do
      subject.execute

      expect(incidents_repository_spy.save).to have_received(:save)
        .with(an_instance_of(Incident))
    end
  end
end