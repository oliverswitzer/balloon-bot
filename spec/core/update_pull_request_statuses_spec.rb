require 'rspec'
require './clients/github/github_client_wrapper'
require './clients/github/status'
require './clients/slack/slack_client_wrapper'
require './core/update_pull_request_statuses'
require './core/hold_deployments'

describe "Integration Test: HoldDeployments + UpdatePullRequestStatuses" do
  let(:github_client_spy) { spy(GithubClientWrapper) }
  let(:incidents_repository) { IncidentsRepository.new }

  let(:hold_deployments) {
    HoldDeployments.new(
      chat_client: spy(SlackClientWrapper),
      github_client: spy(GithubClientWrapper),
      incidents_repository: incidents_repository
    )
  }

  subject do
    UpdatePullRequestStatuses.new(
      github_client: github_client_spy,
      incidents_repository: incidents_repository
    )
  end

  describe '#execute' do
    context 'when deployments have been previously held' do
      before do
        fake_slack_message = { text: 'some message', timestamp: 'some time', channel_id: 'some channel' }
        hold_deployments_request = HoldDeployments::Request.new(message: fake_slack_message)

        hold_deployments.execute(hold_deployments_request)
      end

      context 'for each open PR on the configured github repo' do
        before do
          expect(github_client_spy).to receive(:open_pull_requests)
            .and_return(
              [
                PullRequest.new(head_sha: '123abc', branch: 'some-branch'),
                PullRequest.new(head_sha: '456def', branch: 'some-branch')
              ]
            )

        end

        it 'sets a failing github status' do
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '123abc',
              status: instance_of(Github::FailureStatus)
            )
          expect(github_client_spy).to receive(:set_status_for_commit)
             .with(
               commit_sha: '456def',
               status: instance_of(Github::FailureStatus)
             )

          subject.execute
        end
      end
    end

    context 'when deployments have not been previously held' do
      context 'it does not set failing statuses on open PRs in github' do
        it 'sets a failing github status' do
          expect(github_client_spy).not_to receive(:open_pull_requests)
          expect(github_client_spy).not_to receive(:set_status_for_commit)

          subject.execute
        end
      end
    end
  end
end
