require_relative '../../spec_helper'

describe Core::HoldDeployments do
  let(:slack_client_spy) { spy('Clients::Slack::SlackClientWrapper') }
  let(:github_client_spy) { spy('Clients::Github::GithubClientWrapper') }
  let(:incidents_repository) { FakeIncidentsRepository.new }
  let(:messages_repository) { FakeMessagesRepository.new }

  let(:fake_message) do
    {
      text: 'some message',
      timestamp: '123',
      channel_id: 'abc'
    }
  end

  subject do
    Core::HoldDeployments.new(
      chat_client: slack_client_spy,
      incidents_repository: incidents_repository,
      messages_repository: messages_repository,
      github_client: github_client_spy
    )
  end

  describe '#execute' do
    describe 'tells the channel to hold deploys' do
      context 'when a failure channel topic has been configured' do
        before do
          ENV['FAILURE_CHANNEL_TOPIC'] = 'something bad happened'
        end

        it 'tells slack client to set the channel topic to the configured topic' do
          subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

          expect(slack_client_spy).to have_received(:set_channel_topic)
            .with(message: 'something bad happened')
        end

        after do
          ENV['FAILURE_CHANNEL_TOPIC'] = nil
        end
      end

      context 'when a failure channel topic has not been configured' do
        it 'tells slack client to set the default channel topic for failure' do
          subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

          expect(slack_client_spy).to have_received(:set_channel_topic)
            .with(message: Core::HoldDeployments::DEFAULT_CHANNEL_TOPIC)
        end
      end

      context 'when a slack handle has been configured' do
        before do
          ENV['SLACK_HANDLE_TO_NOTIFY'] = '<!here|here>'
        end

        it 'uses that handle when notifying the configured deployments channel' do
          subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

          expect(slack_client_spy).to have_received(:say)
            .with(message: "<!here|here> #{Core::HoldDeployments::MESSAGE}")
        end

        after do
          ENV['SLACK_HANDLE_TO_NOTIFY'] = nil
        end
      end

      context 'when a slack handle has not been configured' do
        it 'uses @channel handle when notifying the configured deployments channel' do
          subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

          expect(slack_client_spy).to have_received(:say)
            .with(message: "<!channel|channel> #{Core::HoldDeployments::MESSAGE}")
        end
      end
    end

    it 'creates an unresolved incident' do
      subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

      saved_incident = incidents_repository.find_last_unresolved

      expect(saved_incident).to be_an_instance_of(Core::Incident)
      expect(saved_incident.resolved_at).to be_nil
    end

    it 'saves the message that triggered the incident' do
      subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

      incident = incidents_repository.find_last_unresolved

      message = messages_repository.find_by_incident_id(incident.id).first

      expect(message.text).to eq(fake_message[:text])
      expect(message.channel_id).to eq(fake_message[:channel_id])
      expect(message.timestamp).to eq(fake_message[:timestamp])
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

          expect(slack_client_spy).to receive(:url_for_message)
            .with(
              timestamp: fake_message[:timestamp],
              channel_id: fake_message[:channel_id]
            )
            .and_return('http://www.example.com')
            .twice
        end

        it 'sets a failing github status' do
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '123abc',
              more_info_url: 'http://www.example.com',
              status: instance_of(Core::Github::FailureStatus)
            )
          expect(github_client_spy).to receive(:set_status_for_commit)
            .with(
              commit_sha: '456def',
              more_info_url: 'http://www.example.com',
              status: instance_of(Core::Github::FailureStatus)
            )

          subject.execute(Core::HoldDeployments::Request.new(message: fake_message))
        end
      end
    end

    context 'when there is already an unresolved incident' do
      before do
        incidents_repository.save(Core::Incident.new(resolved_at: nil))
      end

      it 'warns that deployments are already being held' do
        subject.execute(Core::HoldDeployments::Request.new(message: fake_message))

        expect(slack_client_spy).to have_received(:say)
          .with(message: Core::HoldDeployments::ERROR_MESSAGES[:already_holding])
      end
    end
  end
end
