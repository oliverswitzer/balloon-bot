require 'rspec'
require './core/continue_deployments'
require './core/entities/incident'
require './clients/slack/slack_client_wrapper'
require './persistence/incidents_repository'

describe ContinueDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  let(:incidents_repository) { IncidentsRepository.new }

  subject do
    ContinueDeployments.new(
      chat_client: slack_client_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
    it 'tells the specified deployments channel to continue deploys' do
      subject.execute

      expect(slack_client_spy).to have_received(:say)
                                    .with(message: SlackClientWrapper::BACK_TO_GREEN_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute

      expect(slack_client_spy).to have_received(:set_channel_topic)
                                    .with(message: SlackClientWrapper::GREEN_CHANNEL_TOPIC)
    end

    it 'resolves the latest, unresolved incident' do
      unresolved_incident = incidents_repository.save(Incident.new(resolved_at: nil))

      subject.execute

      updated_incident = incidents_repository.find(unresolved_incident.id)

      expect(updated_incident.resolved_at).to be_an_instance_of(Time)
    end
  end
end