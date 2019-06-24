require_relative '../../spec_helper'

describe Core::ContinueDeployments do
  let(:slack_client_spy) { spy("SlackClientWrapper") }
  let(:github_client_spy) { spy("GithubClientWrapper") }
  let(:incidents_repository) { FakeIncidentsRepository.new }

  subject do
    Core::ContinueDeployments.new(
      chat_client: slack_client_spy,
      github_client: github_client_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
    it 'tells the specified deployments channel to continue deploys' do
      subject.execute

      expect(slack_client_spy).to have_received(:say)
        .with(message: Core::ContinueDeployments::BACK_TO_GREEN_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute

      expect(slack_client_spy).to have_received(:set_channel_topic)
        .with(message: Core::ContinueDeployments::DEFAULT_CHANNEL_TOPIC)
    end

    context 'when a success channel topic has been configured' do
      before do
        ENV['SUCCESS_CHANNEL_TOPIC'] = 'good to go, yo!'
      end

      it 'tells slack client to set the channel topic to the configured topic' do
        subject.execute

        expect(slack_client_spy).to have_received(:set_channel_topic)
          .with(message: 'good to go, yo!')
      end
    end

    context 'when a success channel topic has not been configured' do
      before do
        ENV['SUCCESS_CHANNEL_TOPIC'] = nil
      end

      it 'tells slack client to set the default channel topic for failure' do
        subject.execute

        expect(slack_client_spy).to have_received(:set_channel_topic)
          .with(message: Core::ContinueDeployments::DEFAULT_CHANNEL_TOPIC)
      end
    end

    describe 'github status behavior' do
      context 'for each open PR on the configured github repo' do
        before do
          expect(github_client_spy).to receive(:open_pull_requests)
            .and_return(
              [
                Core::PullRequest.new(head_sha: '123abc', branch: 'some-branch'),
                Core::PullRequest.new(head_sha: '456def', branch: 'some-branch')
              ]
            )
        end

        it 'sets a github successful github status' do
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '123abc',
              status: instance_of(Core::Github::SuccessStatus)
            )
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '456def',
              status: instance_of(Core::Github::SuccessStatus)
            )

          subject.execute
        end
      end
    end

    it 'resolves the latest, unresolved incident' do
      unresolved_incident = incidents_repository.save(Core::Incident.new(resolved_at: nil))

      subject.execute

      updated_incident = incidents_repository.find(unresolved_incident.id)

      expect(updated_incident.resolved_at).to be_an_instance_of(Time)
    end
  end
end
