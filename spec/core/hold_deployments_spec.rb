require 'rspec'
require './core/hold_deployments'
require './clients/slack/slack_client_wrapper'
require './clients/github/github_client_wrapper'
require './persistence/incidents_repository'

describe HoldDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  let(:github_client_spy) { spy(GithubClientWrapper) }
  let(:incidents_repository) { IncidentsRepository.new }
  let(:fake_message) do
    SlackMessage.new(
      timestamp: '123',
      channel_id: 'abc'
    )
  end

  subject do
    HoldDeployments.new(
      chat_client: slack_client_spy,
      incidents_repository: incidents_repository,
      github_client: github_client_spy
    )
  end

  describe '#execute' do
    it 'tells the specified deployments channel to hold deploys' do
      subject.execute(HoldDeployments::Request.new(triggered_by: fake_message))

      expect(slack_client_spy).to have_received(:say)
        .with(message: SlackClientWrapper::FAILURE_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute(HoldDeployments::Request.new(triggered_by: fake_message))

      expect(slack_client_spy).to have_received(:set_channel_topic)
        .with(message: SlackClientWrapper::FAILURE_CHANNEL_TOPIC)
    end

    it 'creates an unresolved incident' do
      subject.execute(HoldDeployments::Request.new(triggered_by: fake_message))

      saved_incident = incidents_repository.find_last_unresolved

      expect(saved_incident).to be_an_instance_of(Incident)
      expect(saved_incident.resolved_at).to be_nil
    end

    describe 'github status behavior' do
      context 'when there are open PRs on the configured github repo' do
        before do
          expect(github_client_spy).to receive(:open_pull_requests)
            .and_return(
              [
                PullRequest.new(head_sha: '123abc', branch: 'some-branch'),
                PullRequest.new(head_sha: '456def', branch: 'some-branch')
              ]
            )

          expect(slack_client_spy).to receive(:url_for)
            .with(message: fake_message)
            .and_return('http://www.example.com')
            .twice
        end

        it 'sets a github status for each open PR to failure' do
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '123abc',
              state: GithubClientWrapper::FAILURE_STATE,
              context: 'Master is broken',
              description: 'Do not merge into master',
              more_info_url: 'http://www.example.com'
            )
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '456def',
              state: GithubClientWrapper::FAILURE_STATE,
              context: 'Master is broken',
              description: 'Do not merge into master',
              more_info_url: 'http://www.example.com'
            )

          subject.execute(HoldDeployments::Request.new(triggered_by: fake_message))
        end
      end
    end

    context 'when there is already an unresolved incident' do
      before do
        incidents_repository.save(Incident.new(resolved_at: nil))
      end

      it 'warns that deployments are already being held' do
        subject.execute(HoldDeployments::Request.new(triggered_by: fake_message))

        expect(slack_client_spy).to have_received(:say)
          .with(message: SlackClientWrapper::ERROR_MESSAGES[:already_holding])
      end
    end
  end
end
