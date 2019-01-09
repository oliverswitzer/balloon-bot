require 'rspec'
require './core/hold_deployments'
require './slack_client_wrapper'
require './persistence/incidents_repository'


describe HoldDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  let(:incidents_repository) { IncidentsRepository.new }

  subject do
    HoldDeployments.new(
      chat_client: slack_client_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
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

    it 'creates an unresolved incident' do
      subject.execute

      saved_incident = incidents_repository.find_last_unresolved

      expect(saved_incident).to be_an_instance_of(Incident)
      expect(saved_incident.resolved_at).to be_nil
    end

    context 'when there is already an unresolved incident' do
      before do
        incidents_repository.save(Incident.new(resolved_at: nil))
      end

      it 'warns that deployments are already being held' do
        subject.execute

        expect(slack_client_spy).to have_received(:say)
                                      .with(message: SlackClientWrapper::ERROR_MESSAGES[:already_holding])
      end
    end
  end
end