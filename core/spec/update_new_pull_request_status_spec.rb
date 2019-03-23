require_relative './spec_helper'

describe 'Integration Test: HoldDeployments + UpdateNewPullRequestStatus' do
  let(:slack_client_spy) { spy('SlackClientWrapper') }
  let(:github_client_spy) { spy('GithubClientWrapper') }
  let(:incidents_repository) {IncidentsRepository.new}
  let(:messages_repository) {MessagesRepository.new}

  let(:hold_deployments) {
    HoldDeployments.new(
      chat_client: spy('SlackClientWrapper'),
      github_client: spy('GithubClientWrapper'),
      incidents_repository: incidents_repository,
      messages_repository: messages_repository
    )
  }

  subject do
    UpdateNewPullRequestStatus.new(
      github_client: github_client_spy,
      incidents_repository: incidents_repository,
      messages_repository: messages_repository,
      chat_client: slack_client_spy
    )
  end

  describe '#execute' do
    context 'when deployments have been previously held' do
      before do
        # Trigger HoldDeployments
        fake_slack_message = {
          text: 'some message',
          timestamp: 'some time',
          channel_id: 'some channel'
        }
        hold_deployments_request = HoldDeployments::Request.new(message: fake_slack_message)
        hold_deployments.execute(hold_deployments_request)

        # Stub first slack message for that hold deployments call since
        # it is used to generate the more_info_url that folks can click on
        # to see who originally held deployments

        current_incident = incidents_repository.find_last_unresolved
        first_incident_message = messages_repository.find_by_incident_id(
          current_incident.id
        ).first

        expect(slack_client_spy).to receive(:url_for_message)
                                      .with(
                                        timestamp: first_incident_message.timestamp,
                                        channel_id: first_incident_message.channel_id
                                      )
                                      .and_return('http://example.com')
      end

      context 'when pull request event is when a new pull request is opened' do
        it 'sets a failing github status for the passed in pull request' do
          expect(github_client_spy).to receive(:set_status_for_commit)
                                         .with(
                                           commit_sha: '123abc',
                                           status: instance_of(Github::FailureStatus),
                                           more_info_url: 'http://example.com'
                                         )

          subject.execute(
            github_event: PullRequestEvent.new(
              type: PullRequestEvent::OPENED,
              pull_request: PullRequest.new(
                head_sha: '123abc',
                branch: 'some-branch'
              )
            )
          )
        end
      end
    end

    context 'when pull request event is not about when a pull request has been opened' do
      it 'it does not set failing statuses on the passed in pull request in github' do
        expect(github_client_spy).not_to receive(:set_status_for_commit)

        subject.execute(
          github_event: PullRequestEvent.new(
            type: 'foo event',
            pull_request: PullRequest.new(
              head_sha: '123abc',
              branch: 'some-branch'
            )
          )
        )
      end
    end

    context 'when deployments have not been previously held' do
      it 'it does not set failing statuses on the passed in pull request in github' do
        expect(github_client_spy).not_to receive(:set_status_for_commit)

        subject.execute(
          github_event: PullRequestEvent.new(
            type: PullRequestEvent::OPENED,
            pull_request: PullRequest.new(
              head_sha: '123abc',
              branch: 'some-branch'
            )
          )
        )
      end
    end
  end
end
